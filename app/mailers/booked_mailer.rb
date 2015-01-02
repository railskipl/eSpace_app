class BookedMailer < ActionMailer::Base
  default from: "from@example.com"

  def booked_a_spaces(booking)
  	@booking = booking
  	
  	email1 = booking.user_email
    email2 = booking.poster_email

    recipients = email1, email2

    subject = "Booked Details - Dinoba"

  	attachments["Booked_space.pdf"] = WickedPdf.new.pdf_from_string(render_to_string(:pdf => "receipt", :template => 'booked_mailer/booked_a_spaces.pdf.erb'))

  	mail(:subject => subject, :to => "ankit@kunalinfotech.net" ) do |format|
      format.html
    end

  end

end
