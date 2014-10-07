 ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :user_name            => "testmailkipl0@gmail.com",
    :password             => 'kipl12345',
    :authentication       => "plain",
    :enable_starttls_auto => true
  }