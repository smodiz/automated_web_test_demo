module Pages
  #:nodoc:
  class NewFlashCardDeck < Page
    REQUIRED_FIELDS = %w(name description)
    OPTIONAL_FIELDS = %w(tag_list)

    def initialize
      super(url: '/decks/new', form_prefix: 'deck')
    end

    def create(attributes)
      fill_in 'Name', with: attributes[:name]
      fill_in 'Description', with: attributes[:description]
      fill_in 'Tag list (comma sep)', with: attributes[:tag_list]
      click_button 'Create Deck'
      Pages::FlashCardDeck.new
    end

    def click_cancel
      click_link 'Cancel'
      Pages::FlashCardDecks.new
    end
  end
end
