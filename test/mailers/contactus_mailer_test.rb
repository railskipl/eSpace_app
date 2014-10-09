require 'test_helper'

class ContactusMailerTest < ActionMailer::TestCase
  test "contactus" do
    mail = ContactusMailer.contactus
    assert_equal "Contactus", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
