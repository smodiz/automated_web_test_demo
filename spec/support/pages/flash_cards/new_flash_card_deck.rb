module Pages
  #:nodoc:
  class NewFlashCardDeck < Page
    REQUIRED_FIELDS = %w(name description)
    OPTIONAL_FIELDS = %w(tag_list)

    def initialize
      super(url: '/decks/new', form_prefix: 'deck')
    end

    def create(deck, tags)
      fill_in 'Name', with: deck.name
      fill_in 'Description', with: deck.description
      fill_in 'Tag list (comma sep)',
              with: Pages::FlashCardDeck.formatted_tag_list(tags)
      click_button 'Create Deck'
      Pages::FlashCardDeck.new
    end

    def click_cancel
      click_link 'Cancel'
      Pages::FlashCardDecks.new
    end
  end
end
