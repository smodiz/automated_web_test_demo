require 'spec_helper'

# Feature: User creates flash card
# As a User
# I want to add flash cards to decks
# So that I can study them later
feature 'user creates flash card' do
  before(:each) do
    Pages::SignIn.new.sign_in
    deck = FactoryGirl.create(:deck)
    @index_page = Pages::FlashCardDecks.new
    @index_page.visit_page
    @deck_page = @index_page.click_deck_link(deck.name)
  end

  # Scenario: successfully adds flash card
  # Given I have successfully signed in
  # And I navigate to an existing flash card deck
  # When I click the Add Flash Card button
  # And enter valid data and click save
  # Then a flash card is created
  scenario 'succeeds with valid data', js: true do
    flash_card = FactoryGirl.build(:flash_card)

    @deck_page.click_add_flash_card_link
    @deck_page.add_flash_card(flash_card)

    expect(@deck_page).to have_flashcards([flash_card])
  end

  # Scenario: fails to add flash card without required fields
  # Given I have successfully signed in
  # And I navigate to an existing flash card deck
  # When I add multiple flash cards
  # Then multiple flash cards appear on the page
  scenario 'fails with invalid fields', js: true do
    flash_card = FactoryGirl.build(:flash_card, front: '', back: '')

    @deck_page.click_add_flash_card_link
    @deck_page.add_flash_card(flash_card)

    expect(@deck_page).not_to have_any_flashcards
  end

  # Scenario: successfully adds multiple flash cards
  # Given I have successfully signed in
  # And I navigate to an existing flash card deck
  # When I add multiple flash cards
  # Then multiple flash cards appear on the page
  scenario 'succeeds with multiple cards', js: true do
    card_1 = FactoryGirl.build(:flash_card)
    card_2 = FactoryGirl.build(:flash_card)

    @deck_page.click_add_flash_card_link
    @deck_page.add_flash_card(card_1)
    expect(@deck_page).to have_flashcards([card_1])

    @deck_page.add_flash_card(card_2)
    expect(@deck_page).to have_flashcards([card_1, card_2])
  end
end
