# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/enrolled
  def enrolled
    user = User.first
    UserMailer.enrolled(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/updated
  def updated
    user = User.first
    user.active_until = Time.zone.now + 1.month
    user.save!
    UserMailer.updated(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/payment_upcoming
  def payment_upcoming
    UserMailer.payment_upcoming
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/payment_cancelled
  def payment_cancelled
    user = User.first
    amount = 400
    UserMailer.payment_cancelled(user, amount)
  end
  
  # Preview at /rails/mailers/user_mailer/dispute_notification
  def dispute_notification
    id = 00000
    amount = "1000"
    currency = "jpy"
    UserMailer.dispute_notification(id, amount, currency)
  end

end
