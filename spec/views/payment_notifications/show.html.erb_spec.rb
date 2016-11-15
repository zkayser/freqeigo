require 'rails_helper'

RSpec.describe "payment_notifications/show", type: :view do
  before(:each) do
    @payment_notification = assign(:payment_notification, PaymentNotification.create!(
      :params => "Params",
      :status => "Status",
      :payment_id => "Payment"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Params/)
    expect(rendered).to match(/Status/)
    expect(rendered).to match(/Payment/)
  end
end
