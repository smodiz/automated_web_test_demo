require 'spec_helper'

# Feature: User creates flash card deck
#   As a User
#   I want to create a flash card deck
#   So that I can add flash cards to it
#   And be able to study flash cards
feature 'User creates flash card deck' do
  before(:all) do
    @attributes = {
      name: 'Ruby for Newbies',
      tag_list: 'ruby',
      description: 'An overview of basic Ruby'
    }
    @user = User.find_by(email: ENV['QN_USER'])
  end

  before(:each) do
    Pages::SignIn.new.sign_in
    decks_index_page = Pages::FlashCardDecks.new
    decks_index_page.visit_page
    @new_deck_page = decks_index_page.click_create_deck
  end

  # Scenario: successfully create a flash card deck
  # Given that I have successfully signed in
  # When I navigate to the New Deck page
  # And enter valid data into the fields
  # And click the Create Deck button
  # Then a new flash card deck is created
  scenario 'successfully creates deck' do
    create_deck_with(@attributes)
    verify_deck_has(@attributes)
  end

  # Scenario: fail to create deck without entering required fields
  # Given that I have successfully signed in
  # When I navigate to the New Deck page
  # And do not enter required fields
  # Then an error message for each required field is shown
  # And the deck is not created
  scenario 'does not create deck without required fields' do
    invalid_attributes = {
      name: '',
      tag_list: '',
      description: ''
    }
    @new_deck_page.create(invalid_attributes)

    expect(@new_deck_page).to have_generic_page_error
    # require fields should each have a message
    Pages::NewFlashCardDeck::REQUIRED_FIELDS.each do |attr|
      expect(@new_deck_page).to have_required_field_message_for(attr)
    end
    # optional fields should not have an error message
    Pages::NewFlashCardDeck::OPTIONAL_FIELDS.each do |attr|
      expect(@new_deck_page).not_to have_required_field_message_for(attr)
    end
  end

  # Scenario: successfully create a deck using an existing tag
  # Given that I have successfully signed in
  # When I create a new flash card deck using a pre-existing tag
  # Then the deck is created successfully
  # And an additional tag is NOT created in the database
  scenario 'successfully create a deck using an existing tag' do
    # need a pre-existing tag to re-use. For speed, insert the
    # test data directly into test database
    TestDataFactory::TestDeck.create(
      {
        name: 'xy',
        description: 'wx',
        tag_list: @attributes[:tag_list]
      },
      @user
    )

    # create another deck, with the same tag name
    create_deck_with(@attributes)
    verify_deck_has(@attributes)

    # also, check the database directly. should have 2 decks, but 1 tag
    expect(Deck.where(user_id: @user.id).count).to eq 2
    expect(Tag.where(name: @attributes[:tag_list]).count).to eq 1
  end

  # Scenario: successfully create a deck with multiple tags
  # Given that I have successfully logged in
  # When I create a flash card deck using multiple tags
  # Then the deck is created successfully
  # And all the tags appear in alphabetical order on the new Deck page
  scenario 'successfully create a deck with multiple tags' do
    attributes = {
      name: 'Design Pattern in Ruby',
      tag_list: 'ruby, design--patterns',
      description: 'The GoF Design Patterns using Ruby'
    }
    create_deck_with(attributes)
    verify_deck_has(attributes)
  end

  # Scenario: successfully create a deck with a tag with special characters
  # Given that I have successfully logged in
  # When I create a flash card deck using a tag with special characters
  # Then the deck is created successfully
  scenario 'create deck with a tag that has special characters' do
    attributes = {
      name: 'Some name',
      tag_list: "~`!@#$%^&*()_-+=\|{}[]'\"?<>.",
      description: 'Some description'
    }
    create_deck_with(attributes)
    verify_deck_has(attributes)
  end

  # Scenario:  successfully create a deck using a new tag containing spaces
  # Given that I have successfully signed in
  # When I create a new flash card deck using a new tag with spaces
  # Then the deck is created successfully
  scenario 'create deck with a tag containing spaces' do
    attributes = {
      name: 'Some name',
      tag_list: 'tag with spaces',
      description: 'Some description'
    }
    create_deck_with(attributes)
    verify_deck_has(attributes)
  end

  # Scenario: successfully create a deck using duplicate tag names
  # Given that I have successfully signed in
  # When I create a new flash card deck using new tags which have the same name
  # Then the deck is created successfully
  # And the system only creates one tag
  scenario 'create a deck using duplicate tags names' do
    attributes = {
      name: 'Some name',
      tag_list: 'ruby, ruby, ruby',
      description: 'Some description'
    }
    create_deck_with(attributes)
    verify_deck_has(attributes)
    expect(Tag.where(name: @attributes[:tag_list]).count).to eq 1
  end

  # Scenario: cancel creating a new flash card deck
  # Given that I have successfully logged in
  # And I have navigated to the New Flash Card Deck page
  # When I click the Cancel button a deck is not created
  # And I am returned to the Decks index page
  scenario 'cancel creating a new flash card deck' do
    decks_index_page = @new_deck_page.click_cancel
    expect(decks_index_page).to have_no_decks
  end
end

def create_deck_with(attributes)
  @deck_page = @new_deck_page.create(attributes)
end

def verify_deck_has(attributes)
  expect(@deck_page).to have_deck_with_attributes(attributes)
  expect(@deck_page).to have_successful_save_message
end
