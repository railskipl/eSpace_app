class OrderMailer < ActionMailer::Base
  default from: "support@dinobo.com"

  def order_status(booking, post)
    @booking = booking
    @post = post
    @user = booking.user.full_name
    @poster = booking.poster.full_name
    subject = "Changed the status of your booking"
    mail(
      :subject => subject,
      :to => booking.user.email
      )
  end
end
