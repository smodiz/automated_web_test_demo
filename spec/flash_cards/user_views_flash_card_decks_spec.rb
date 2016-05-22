require 'spec_helper'

# Feature: View flash card decks
#   As a user
#   I want to view the decks I have authored
#   So I can view, edit, or delete them
feature 'user views deck' do
  before(:all) do
    create_decks_for_user
    create_deck_for_another_user

    Pages::SignIn.new.sign_in
    @decks_index_page = Pages::FlashCardDecks.new
    @decks_index_page.visit_page
  end

  # Scenario: successfully views flash card decks
  # Given that flash card decks exist in the system for me and other users
  # And that I have successfully signed in
  # When I navigate to the index page for decks
  # Then I am able to see the decks I have authored
  # And I am not able to see the decks of other users
  scenario 'successfully views own decks' do
    expect(@decks_index_page).to have_deck(@decks[0].name)
    expect(@decks_index_page).to have_deck(@decks[1].name)
  end

  scenario 'cannot view other user''s deck' do
    expect(@decks_index_page).not_to have_deck(@other_deck.name)
  end

  after(:all) do
    @other_user.destroy
  end

  private

  def create_decks_for_user
    @decks = [FactoryGirl.create(:deck), FactoryGirl.create(:deck)]
  end

  def create_deck_for_another_user
    @other_user = create_other_user
    @other_deck = FactoryGirl.create(:deck, user: @other_user)
  end

  def create_other_user
    other_user = Faker::Internet.email
    dashboard_page = Pages::SignUp.new.sign_up(
      username: other_user,
      password: Faker::Internet.password(8))
    dashboard_page.menu.sign_out
    User.where(email: other_user).first
  end
end
