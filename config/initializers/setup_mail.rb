 ActionMailer::Base.smtp_settings = {
 	:domain               => "gmail.com",
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :user_name            => "testmailkipl0@gmail.com",
    :password             => 'kipl123456789',
    :authentication       => "plain",
    :enable_starttls_auto => true
  }