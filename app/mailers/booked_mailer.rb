class BookedMailer < ActionMailer::Base
  default from: "support@dinobo.com"

  def booked_a_spaces(booking)
    @booking = booking
    email1 = booking.user_email
    email2 = booking.poster_email
    recipients = email1, email2
    subject = "Booked Details - Dinobo"
    attachments["Booked_space.pdf"] = WickedPdf.new.pdf_from_string(render_to_string(:pdf => "receipt", :template => 'booked_mailer/booked_a_spaces.pdf.erb'))
    mail(:subject => subject, :to => recipients.join(',') ) do |format|
      format.html
    end
  end

  def booking_status(booking)
    @booking = booking
    @area = booking.post.area_available
    @poster = booking.poster.full_name
    subject = "Cancellation booking"
    mail(
      :subject => subject,
      :to => booking.poster.email
      )
  end

  def booking_payment(booking)
    @booking = booking
    @poster = booking.poster.full_name
    subject = "Transfer of funds"
    mail(
      :subject => subject,
      :to => booking.poster.email
      )
  end
end
