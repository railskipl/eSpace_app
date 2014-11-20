class NotificationMailer < ActionMailer::Base
  default from: "rubyrails9@gmail.com"

  def booking_notification(poster_id,random_code)
	@random_code = random_code
	@poster = poster_id
	subject = "Booking Confirmation Notification"
	mail(:subject => subject, :to => poster.email)
  end
end
