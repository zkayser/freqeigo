class ChargesController < ApplicationController
  
  def new
    @plan_hash = JSON.parse params[:format]
    @plan = Stripe::Plan.retrieve(@plan_hash["id"])
  end
  
  def create
  # Amount in cents
  @amount = 2000
  
  unless current_user.nil?
    customer = associate_customer_user

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Test charge',
      :currency    => 'jpy'
    )
    redirect_to current_user
  end

  rescue Stripe::CardError => e
  flash[:error] = e.message
  redirect_to new_charge_path
  end
  
  protected
  
  def associate_customer_user
    if user = current_user
      customer = Stripe::Customer.create(
        :email => params[:stripeEmail],
        :source => params[:stripeToken]
      )
      user.update_attributes!(
        stripe_token: params[:stripeToken],
        stripe_customer_id: customer.id
        )
      return customer
    else
    flash[:warning] = "Please log in to before subscribing."
    redirect_to root_url
    end
  end
end
