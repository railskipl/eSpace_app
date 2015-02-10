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
    @armoring = booking.user.full_name
    subject = "Changed the status of your booking"
    mail(
      :subject => subject,
      :to => booking.user.email
      )
  end
end
