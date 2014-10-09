# Preview all emails at http://localhost:3000/rails/mailers/contactus_mailer
class ContactusMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/contactus_mailer/contactus
  def contactus
    ContactusMailer.contactus
  end

end
