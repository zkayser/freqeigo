class WebhooksController < ApplicationController
  
  protect_from_forgery :except => :stripe_event
  
  def stripe_event
    head :ok
    @event_json = JSON.parse(request.body.read)
    @object_id = @event_json["id"]
    puts "Object ID: #{@object_id}"
    case @event_json["type"]
      when "customer.subscription.created"
        customer = @event_json["data"]["object"]["customer"]
        @user = User.find_by(stripe_customer_id: customer)
        UserMailer.enrolled(@user).deliver_now
      when "invoice.payment_succeeded"
        customer = @event_json["data"]["object"]["customer"]
        @user = User.find_by(stripe_customer_id: customer)
        active_until_date = @event_json["data"]["object"]["lines"]["data"][0]["period"]["end"]
        @user.active_until = Time.at(active_until_date).to_datetime
        @user.save!
        UserMailer.updated(@user).deliver_now
      when "invoice.payment_failed"
        customer = @event_json["data"]["object"]["customer"]
        @user = User.find_by(stripe_customer_id: customer)
        @amount = @event_json["data"]["object"]["amount_due"]
        UserMailer.payment_cancelled(@user, @amount).deliver_now
      when "charge.dispute.created"
        dispute_id = @event_json["data"]["object"]["id"]
        amount = @event_json["data"]["object"]["amount"]
        currency = @event_json["data"]["object"]["currency"]
        UserMailer.dispute_notification(dispute_id, amount, currency).deliver_now
      when "charge.succeeded" # Not really sure what to do with this yet — Check if the customer identity exists?
        customer = @event_json["data"]["object"]["customer"]
        begin
          @user = User.find_by(stripe_customer_id: customer)
        rescue
          puts "Stripe Customer ID not found in database."
        end
        # Down here, you might want to send a notification to the admin that a charge succeeded but no user was found
        # with the matching Stripe ID.
    end
  end
  
  def index
    @events = ["This", "is", "just", "a", "test"]
  end
    
  
  
end
