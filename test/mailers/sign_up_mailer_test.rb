require "test_helper"

class SignUpMailerTest < ActionMailer::TestCase
  test "validate_email" do
    mail = SignUpMailer.validate_email("testuser1", "test@example.com", "localhost:3000")
    assert_equal ["test@example.com"], mail.to
    assert_equal ["helloworld"], mail.from
    assert_match "testuser1", mail.body.encoded
    assert_match "validate?key=", mail.body.encoded
  end
end
