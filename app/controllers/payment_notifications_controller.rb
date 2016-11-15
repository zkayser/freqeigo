class PaymentNotificationsController < ApplicationController
  protect_from_forgery except: [:create]
  before_action :set_payment_notification, only: [:show, :edit, :update, :destroy]
  before_action :current_admin?

  def index
    @payment_notifications = PaymentNotification.all.to_a
    render 'payments/index'
  end
  
  # POST /payment_notifications
  # POST /payment_notifications.json
  
  def create
    PaymentNotification.create!(params: params, status: params[:payment_status], transaction_id: params[:txn_id])
    render :nothing => true
  end
  
  protected 
  def validate_IPN_notification(raw)
    uri = URI.parse('https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_notify-validate')
    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 60
    http.read_timeout = 60
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.use_ssl = true
    response = http.post(uri.request_uri, raw,
                         'Content-Length' => "#{raw.size}",
                         'User-Agent' => "My custom user agent"
                       ).body
    return response
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_notification
      @payment_notification = PaymentNotification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_notification_params
      params.require(:payment_notification).permit(:params, :status, :payment_id)
    end
end
