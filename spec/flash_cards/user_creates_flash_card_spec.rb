require 'spec_helper'

# Feature: User creates flash card
# As a User
# I want to add flash cards to decks
# So that I can study them later
feature 'user creates flash card' do
  before(:all) do
    @user = User.find_by(email: ENV['QN_USER'])
  end

  before(:each) do
    Pages::SignIn.new.sign_in
    @deck_attributes = {
      name: 'Lola von Schnauzer',
      tag_list: 'dogs',
      description: 'Learn about Lola'
    }
    TestDataFactory::TestDeck.create(
      @deck_attributes,
      @user
    )
    @index_page = Pages::FlashCardDecks.new
    @index_page.visit_page
    deck_name = @deck_attributes[:name]
    @deck_page = @index_page.click_deck_link(deck_name)
  end

  # Scenario: successfully adds flash card
  # Given I have successfully signed in
  # And I navigate to an existing flash card deck
  # When I click the Add Flash Card button
  # And enter valid data and click save
  # Then a flash card is created
  scenario 'successfully', js: true do
    flash_card_attributes = {
      front: "What is Lola's favorite toy?",
      back: 'Tennis ball',
      difficulty: 'Beginner'
    }
    @deck_page.click_add_flash_card_link
    @deck_page.add_flash_card(flash_card_attributes)
    expect(@deck_page).to have_flashcards([flash_card_attributes])
  end

  # Scenario: successfully adds multiple flash cards
  # Given I have successfully signed in
  # And I navigate to an existing flash card deck
  # When I add multiple flash cards
  # Then multiple flash cards appear on the page
  scenario 'with multiple cards', js: true do
    card_1 = {
      front: "What is Lola's favorite toy?",
      back: 'Tennis ball',
      difficulty: 'Beginner'
    }
    card_2 = {
      front: 'Who does Lola bark at?',
      back: 'Everyone!',
      difficulty: 'Beginner'
    }
    @deck_page.click_add_flash_card_link
    @deck_page.add_flash_card(card_1)
    expect(@deck_page).to have_flashcards([card_1])
    @deck_page.add_flash_card(card_2)
    expect(@deck_page).to have_flashcards([card_1, card_2])
  end

  # Scenario: fails to add flash card without required fields
  # Given I have successfully signed in
  # And I navigate to an existing flash card deck
  # When I add multiple flash cards
  # Then multiple flash cards appear on the page
  scenario 'fails with invalid fields', js: true do
    card_1 = {
      front: '',
      back: '',
      difficulty: 'Beginner'
    }
    @deck_page.click_add_flash_card_link
    @deck_page.add_flash_card(card_1)
    expect(@deck_page).not_to have_any_flashcards
  end
end
