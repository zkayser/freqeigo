class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.enrolled.subject
  #
  def enrolled(user)
    @user = user
    @email = user.email
    
    
    mail to: @email,
    subject: "Thank you for registering."
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.updated.subject
  #
  def updated(user)
    @user = user
    @email = @user.email

    mail to: @email,
    subject: "Subscription Payment Received"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.payment_upcoming.subject
  #
  def payment_upcoming
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.payment_cancelled.subject
  #
  def payment_cancelled(user, amount)
    @user = user
    @amount = sprintf("$%0.2f", (amount/100))
    

    mail to: @user.email,
    subject: "Your most recent invoice payment failed"
  end
  
  # Send email to me when a dispute is created
  def dispute_notification(id, amount, currency)
    @id, @amount, @currency = id, amount, currency
    
    mail to: "kaysertranslation@gmail.com",
    subject: "Hikarigo dispute created. Attention may be needed"
  end
end
