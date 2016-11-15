class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: [:show, :edit, :update, :destroy]
  protect_from_forgery except: [:create]
  
  # GET /subscriptions
  # GET /subscriptions.json
  def index
    @subscriptions = Subscription.all
  end

  # GET /subscriptions/1
  # GET /subscriptions/1.json
  def show
  end

  # GET /subscriptions/new
  def new
    @subscription = Subscription.new
  end

  # GET /subscriptions/1/edit
  def edit
  end

  # POST /subscriptions
  # POST /subscriptions.json
  def create
    params.permit(:interval, :plan, :stripeEmail, :stripeToken)
    if current_user
      @user = current_user
      begin
      customer = Stripe::Customer.create(
        :email => params[:stripeEmail],
        :source => params[:stripeToken],
        :plan => params[:plan]
        )
      if @user.plan.nil? || @user.plan != params[:plan]
        case params[:interval]
          when "month"
            active_date_increment = Time.now + 1.month
          when "year"
            active_date_increment = Time.now + 1.year
          when "week"
            active_date_increment = Time.now + 1.week
        end
        @user.update_attributes!(
            stripe_customer_id: customer.id,
            active_until: active_date_increment,
            plan: params[:plan],
            stripe_token: params[:stripeToken]
          )
      end
      redirect_to @user
      rescue
        puts "Unable to register customer with Stripe: #{params[:stripeEmail]}"
        flash[:alert] = "There was an error processing the payment. Please try again."
        redirect_to plan_path(Stripe::Plan.retrieve(params[:plan]))
      end
    end
  end

  # PATCH/PUT /subscriptions/1
  # PATCH/PUT /subscriptions/1.json
  def update
    respond_to do |format|
      if @subscription.update(subscription_params)
        format.html { redirect_to @subscription, notice: 'Subscription was successfully updated.' }
        format.json { render :show, status: :ok, location: @subscription }
      else
        format.html { render :edit }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # Possibly use this method to create a Stripe Refund object to refund a user
  # if they request to be refunded. Fair enough.
  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.json
  def destroy
    @subscription.destroy
    respond_to do |format|
      format.html { redirect_to subscriptions_url, notice: 'Subscription was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subscription
      @subscription = Subscription.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subscription_params
      params.permit(:stripeEmail, :stripeToken, :plan, :interval)
    end
end
