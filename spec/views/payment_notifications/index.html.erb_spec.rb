require 'rails_helper'

RSpec.describe "payment_notifications/index", type: :view do
  before(:each) do
    assign(:payment_notifications, [
      PaymentNotification.create!(
        :params => "Params",
        :status => "Status",
        :payment_id => "Payment"
      ),
      PaymentNotification.create!(
        :params => "Params",
        :status => "Status",
        :payment_id => "Payment"
      )
    ])
  end

  it "renders a list of payment_notifications" do
    render
    assert_select "tr>td", :text => "Params".to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
    assert_select "tr>td", :text => "Payment".to_s, :count => 2
  end
end
