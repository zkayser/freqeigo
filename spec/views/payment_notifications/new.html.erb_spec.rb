require 'rails_helper'

RSpec.describe "payment_notifications/new", type: :view do
  before(:each) do
    assign(:payment_notification, PaymentNotification.new(
      :params => "MyString",
      :status => "MyString",
      :payment_id => "MyString"
    ))
  end

  it "renders new payment_notification form" do
    render

    assert_select "form[action=?][method=?]", payment_notifications_path, "post" do

      assert_select "input#payment_notification_params[name=?]", "payment_notification[params]"

      assert_select "input#payment_notification_status[name=?]", "payment_notification[status]"

      assert_select "input#payment_notification_payment_id[name=?]", "payment_notification[payment_id]"
    end
  end
end
