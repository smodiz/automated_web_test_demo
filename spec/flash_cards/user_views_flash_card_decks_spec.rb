require 'spec_helper'

# Feature: View flash card decks
#   As a user
#   I want to view the decks I have authored
#   So I can view, edit, or delete them
feature 'user views deck' do
  before(:all) do
    create_other_user_and_deck
    create_default_user_and_deck
  end

  # Scenario: successfully views flash card decks
  # Given that flash card decks exist in the system for me and other users
  # And that I have successfully signed in
  # When I navigate to the index page for decks
  # Then I am able to see the decks I have authored
  # And I am not able to see the decks of other users
  scenario 'successfully' do
    decks_index_page = Pages::FlashCardDecks.new
    decks_index_page.visit_page

    expect(decks_index_page).to have_deck(@deck1.name)
    expect(decks_index_page).to have_deck(@deck2.name)
    expect(decks_index_page).not_to have_deck(@other_deck.name)
  end

  after(:all) do
    User.find_by(email: 'other@example.com').destroy
  end
end

# helper methods

def create_other_user_and_deck
  # create other user via Sign up page
  name = 'other@example.com'
  passwd = 'other123'
  dashboard_page = Pages::SignUp.new.sign_up(username: name, password: passwd)
  dashboard_page.menu.sign_out

  # create deck for other user directly in database for speed
  @other_user = User.find_by(email: name)
  @other_deck = TestDataFactory::TestDeck.create_deck_for(
    user: @other_user,
    deck_number: 3)
end

def create_default_user_and_deck
  @user = default_user
  @deck1 = TestDataFactory::TestDeck.create_deck_for(
    user: @user,
    deck_number: 1)
  @deck2 = TestDataFactory::TestDeck.create_deck_for(
    user: @user,
    deck_number: 2)
end

def default_user
  Pages::SignIn.new.sign_in
  User.find_by(email: ENV['QN_USER'])
end
