class ContactusMailer < ActionMailer::Base
  default from: "contactus@dinobo.com"

  def contactus(contact)
    @contactus = contact
    mail(:subject => '[dinobo.com] Contact us form', :to => "support@dinobo.com")
  end
end
