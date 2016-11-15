class Registration
  include Mongoid::Document
  belongs_to :user
  field :created_at, type: Time
  field :notification_params, type: Hash
  field :status, type: String
  field :purchased_at, type: Time
  
  def paypal_url(return_path)
    values = {
        business: "kaysertranslation-facilitator@gmail.com",
        cmd: "_xclick",
        upload: 1,
        return: "https://rails-tutorial-zkayser.c9.io/",
        invoice: id,
        amount: "10.00",
        item_name: "Standard Course",
        item_number: '1',
        quantity: '1',
        notify_url: "https://rails-tutorial-zkayser.c9.io/payment_notifications/create"
    }
    "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
  end
end
