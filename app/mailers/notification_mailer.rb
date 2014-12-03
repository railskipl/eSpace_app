class NotificationMailer < ActionMailer::Base
  default from: "rubyrails9@gmail.com"

  def booking_notification(booking)
	@booking = booking
	email = User.where(id:@booking[:poster_id]).first.personal_email
	subject = "Booking Confirmation Notification"
	mail(:subject => subject, :to =>email)
  end
end
