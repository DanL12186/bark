require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @valid_user = User.create(email: 'john@bark.com', password: "secretpassword128")
    @user_without_password = User.create(email: "email@this.net")
    @user_with_short_password = User.create(email: "email@this.net")
    @user_without_email = User.create(password: "secretpassword128")
  end

  test 'invalid without email' do
    assert_not @user_without_email.valid?, 'user is invalid without an email'
    assert @user_without_email.errors.messages[:email].include?("can't be blank")
  end

  test 'invalid without password' do
    assert_not @user_without_password.valid?, 'user is valid without a password'
    assert @user_without_password.errors.messages[:password].include?("can't be blank")
  end

  test 'invalid when password too short' do
    assert_not @user_without_password.valid?, 'user is valid without a password'
    
    assert @user_with_short_password.errors.messages[:password].any? { | msg | msg.match?(/too short/)}
  end

  test 'invalid if not unique' do
    user_copy = User.create(@valid_user.attributes.merge(password: 'xyz123'))
    
    assert user_copy.errors.messages[:email].include?("has already been taken")
  end

  test 'valid user' do
    assert @valid_user.valid?
  end
end