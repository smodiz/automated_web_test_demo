require 'spec_helper'

# Feature: Sign in
#   As a User
#   I want to sign in
#   So I can use the application
feature 'User Signs In' do

  # Scenario: User can sign in with valid credentials
  #   Given I have valid credentials
  #   When I navigate to the Sign in page
  #   And I enter in a valid username and password
  #   Then I am able to log in succussfully
  scenario 'signs you in with valid credentials' do
    Pages::SignIn.sign_in
    expect(Pages::SignIn).to have_success_message
  end

  # Scenario: User cannot sign in with bad username
  #   Given I have an invalid username
  #   When I navigate to the Sign in page
  #   And I enter in an invalid username and a password
  #   Then I am not able to log in successfully
  scenario 'does not sign you in with invalid username' do
    Pages::SignIn.sign_in(username: 'Invalid')
    expect(Pages::SignIn).to have_error_message
  end

  # Scenario: User cannot sign in with valid username but invalid password
  #   Given I have a valid username but an invalid password
  #   When I navigate to the Sign in page
  #   And I enter in an valid username and invalid password
  #   Then I am not able to log in successfully
  scenario 'does not sign you in with invalid password' do
    Pages::SignIn.sign_in(password: 'invalid')
    expect(Pages::SignIn).to have_error_message
  end
end
