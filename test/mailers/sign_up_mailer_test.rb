require 'test_helper'

class SignUpMailerTest < ActionMailer::TestCase
  test "validate_email" do
    mail = SignUpMailer.validate_email
    assert_equal "Validate email", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
