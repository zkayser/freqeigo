class PlansController < ApplicationController
  require "stripe"
  Stripe.api_key = ENV['SECRET_KEY']
  def index
    @plans = Stripe::Plan.all
  end
  
  def new
    @plan = Plan.new
  end
  
  def create
    @plan = Stripe::Plan.create!(name: params[:name], interval: params[:interval], amount: params[:amount], currency: 'jpy', )
    @plan = Plan.new
    @plan.save!
    redirect_to plans_path
  end
  
  def show
    @plan_hash = JSON.parse params[:id]
    @plan = Stripe::Plan.retrieve(@plan_hash["id"])
  end
  
  def edit
    @plan = Plan.find(params[:id])
  end

  def update
    @plan = Plan.find(params[:id])
    respond_to do |format|
      if @plan.update(plan_params)
        format.html { redirect_to @plan, notice: 'Plan was successfully updated.' }
        format.json { render :show, status: :ok, location: @plan }
      else
        format.html { render :edit }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy
    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Plan was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private
  # White list
  def plan_params
    params.require(:plan).permit(:name, :price)
  end
end
