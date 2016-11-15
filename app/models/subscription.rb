class Subscription
  include Mongoid::Document
  has_many :payment_notifications
  field :params, type: Hash
  field :name, type: String
  field :price, type: Integer
  field :start_date, type: Time
  field :paypal_payer_id, type: String
  field :paypal_profile_id, type: String
  field :transaction_id, type: String
  
  # Just experimenting...
  def paypal_url
    values = {
        business: "kaysertranslation-facilitator@gmail.com",
        cmd: "_xclick",
        upload: 1,
        return: "https://rails-tutorial-zkayser.c9.io/subscriptions",
        invoice: id,
        amount: "1.00",
        item_name: "Standard Course",
        item_number: '1',
        quantity: '1',
        notify_url: "https://rails-tutorial-zkayser.c9.io/payment_notifications"
    }
    "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
  end
end
