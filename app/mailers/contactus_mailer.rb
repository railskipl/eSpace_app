class ContactusMailer < ActionMailer::Base
  default from: "rubyrails9@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contactus_mailer.contactus.subject
  #

def contactus(contactus)
@contactus = contactus
subject = "Contactus"
	mail(:subject => 'Contactus', :to => "mayuri.supe@kunalinfotech.net")
end
end
