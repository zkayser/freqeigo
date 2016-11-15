require 'rails_helper'

RSpec.describe "payment_notifications/edit", type: :view do
  before(:each) do
    @payment_notification = assign(:payment_notification, PaymentNotification.create!(
      :params => "MyString",
      :status => "MyString",
      :payment_id => "MyString"
    ))
  end

  it "renders the edit payment_notification form" do
    render

    assert_select "form[action=?][method=?]", payment_notification_path(@payment_notification), "post" do

      assert_select "input#payment_notification_params[name=?]", "payment_notification[params]"

      assert_select "input#payment_notification_status[name=?]", "payment_notification[status]"

      assert_select "input#payment_notification_payment_id[name=?]", "payment_notification[payment_id]"
    end
  end
end
