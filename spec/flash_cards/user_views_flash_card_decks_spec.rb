require 'spec_helper'

feature 'user views deck' do
  before(:all) do
    create_decks_for_user
    create_deck_for_another_user

    Pages::SignIn.sign_in
    Pages::FlashCardDecks.visit
  end

  scenario 'successfully views own decks' do
    expect(Pages::FlashCardDecks).to have_deck(@decks[0].name)
    expect(Pages::FlashCardDecks).to have_deck(@decks[1].name)
  end

  scenario 'cannot view other user''s deck' do
    expect(Pages::FlashCardDecks).not_to have_deck(@other_deck.name)
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
    other_user_name = Faker::Internet.email
    other_user_passwd =  Faker::Internet.password(8)
    Pages::SignUp.sign_up username: other_user_name, password: other_user_passwd
    Pages::Dashboard.sign_out
    User.where(email: other_user_name).first
  end
end
