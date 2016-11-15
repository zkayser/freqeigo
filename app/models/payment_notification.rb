class PaymentNotification
  include Mongoid::Document
  belongs_to :subscription
  field :params, type: Hash
  field :status, type: String
  field :payment_id, type: String
  field :transaction_id, type: String
  
  
  def notify
    if status == "Completed"
      subscription.update_attribute!(start_date, Time.now)
    end
  end
end
