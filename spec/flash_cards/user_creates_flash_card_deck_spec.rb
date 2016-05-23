require 'spec_helper'

# Feature: User creates flash card deck
#   As a User
#   I want to create a flash card deck
#   So that I can add flash cards to it
#   And be able to study flash cards
feature 'User creates flash card deck' do

  before(:each) do
    Pages::SignIn.sign_in
    Pages::FlashCardDecks.visit
    Pages::FlashCardDecks.click_create_deck
  end

  # Scenario: successfully create a flash card deck
  # Given that I have successfully signed in
  # When I navigate to the New Deck page
  # And enter valid data into the fields
  # And click the Create Deck button
  # Then a new flash card deck is created
  scenario 'succeeds with valid data' do
    deck = FactoryGirl.build(:deck)
    tag = FactoryGirl.build(:tag)
    
    Pages::NewFlashCardDeck.create(deck, [tag])

    expect(Pages::FlashCardDeck).to have_deck(deck, [tag])
    expect(Pages::FlashCardDeck).to have_successful_save_message
  end

  # Scenario: fail to create deck without entering required fields
  # Given that I have successfully signed in
  # When I navigate to the New Deck page
  # And do not enter required fields
  # Then an error message for each required field is shown
  # And the deck is not created
  scenario 'fails without required fields' do
    invalid_deck = FactoryGirl.build(:deck, name: '', description: '')
    Pages::NewFlashCardDeck.create(invalid_deck, [])

    expect(Pages::NewFlashCardDeck.page).to have_generic_page_error
    # require fields should each have a message
    Pages::NewFlashCardDeck::REQUIRED_FIELDS.each do |attr|
      expect(Pages::NewFlashCardDeck.page).to have_required_field_message_for(attr)
    end
    # optional fields should not have an error message
    Pages::NewFlashCardDeck::OPTIONAL_FIELDS.each do |attr|
      expect(Pages::NewFlashCardDeck.page).not_to have_required_field_message_for(attr)
    end
  end

  # Scenario: successfully create a deck using an existing tag
  # Given that I have successfully signed in
  # When I create a new flash card deck using a pre-existing tag
  # Then the deck is created successfully
  # And an additional tag is NOT created in the database
  scenario 'succeeds using an existing tag' do
    # Need to insert a tag into the database to re-use.
    tagging = FactoryGirl.create(:tagging)
    deck = FactoryGirl.build(:deck)

    # create another deck, with the same tag name
    Pages::NewFlashCardDeck.create(deck, [tagging.tag])
    expect(Pages::FlashCardDeck).to have_deck(deck, [tagging.tag])
    expect(Pages::FlashCardDeck).to have_successful_save_message

    # check the database directly. should have 2 decks, but 1 tag
    expect(Deck.where(user_id: deck.user_id).count).to eq 2
    expect(Tag.where(name: tagging.tag.name).count).to eq 1
  end

  # Scenario: successfully create a deck with multiple tags
  # Given that I have successfully logged in
  # When I create a flash card deck using multiple tags
  # Then the deck is created successfully
  # And all the tags appear in alphabetical order on the new Deck page
  scenario 'succeeds using multiple tags' do
    deck = FactoryGirl.build(:deck)
    tag = FactoryGirl.build(:tag)
    tag_2 = FactoryGirl.build(:tag)

    Pages::NewFlashCardDeck.create(deck, [tag, tag_2])

    expect(Pages::FlashCardDeck).to have_deck(deck, [tag, tag_2])
    expect(Pages::FlashCardDeck).to have_successful_save_message
  end

  # Scenario: successfully create a deck with a tag with special characters
  # Given that I have successfully logged in
  # When I create a flash card deck using a tag with special characters
  # Then the deck is created successfully
  scenario 'succeeds using a tag with special characters' do
    deck = FactoryGirl.build(:deck)
    special_tag = FactoryGirl.build(:tag, name: "~`!@#$%^&*()_-+=\|{}[]'\"?<>.")

    Pages::NewFlashCardDeck.create(deck, [special_tag])

    expect(Pages::FlashCardDeck).to have_deck(deck, [special_tag])
    expect(Pages::FlashCardDeck).to have_successful_save_message
  end

  # Scenario:  successfully create a deck using a new tag containing spaces
  # Given that I have successfully signed in
  # When I create a new flash card deck using a new tag with spaces
  # Then the deck is created successfully
  scenario 'succeeds using a tag containing spaces' do
    deck = FactoryGirl.build(:deck)
    spaces_tag = FactoryGirl.build(:tag, name: 'tag with spaces')

    Pages::NewFlashCardDeck.create(deck, [spaces_tag])

    expect(Pages::FlashCardDeck).to have_deck(deck, [spaces_tag])
    expect(Pages::FlashCardDeck).to have_successful_save_message
  end

  # Scenario: successfully create a deck using duplicate tag names
  # Given that I have successfully signed in
  # When I create a new flash card deck using new tags which have the same name
  # Then the deck is created successfully
  # And the system only creates one tag
  scenario "doesn't create multiple tags when using duplicate tags names" do
    deck = FactoryGirl.build(:deck)
    tag = FactoryGirl.build(:tag)
    duplicate_tag = FactoryGirl.build(:tag, name: tag.name)

    Pages::NewFlashCardDeck.create(deck, [tag, duplicate_tag])

    expect(Pages::FlashCardDeck).to have_deck(deck, [tag, duplicate_tag])
    expect(Pages::FlashCardDeck).to have_successful_save_message
    # check the database directly, in addition to the browser
    expect(Tag.where(name: tag.name).count).to eq 1
  end

  # Scenario: cancel creating a new flash card deck
  # Given that I have successfully logged in
  # And I have navigated to the New Flash Card Deck page
  # When I click the Cancel button a deck is not created
  # And I am returned to the Decks index page
  scenario 'can cancel the operation successfully' do
    Pages::NewFlashCardDeck.click_cancel

    expect(Pages::FlashCardDecks).to have_no_decks
    expect(Deck.count).to eq 0 # check database directly
  end
end
