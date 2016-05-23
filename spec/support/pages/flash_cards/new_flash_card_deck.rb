module Pages
  # This class represents the New Deck Page
  class NewFlashCardDeck
    REQUIRED_FIELDS = %w(name description)
    OPTIONAL_FIELDS = %w(tag_list)
    URL = '/decks/new'
    FORM_PREFIX = 'deck'

    def self.create(deck, tags)
      page.fill_in 'Name', with: deck.name
      page.fill_in 'Description', with: deck.description
      page.fill_in(
        'Tag list (comma sep)',
        with: Pages::FlashCardDeck.formatted_tag_list(tags))
      page.click_button 'Create Deck'
    end

    def self.click_cancel
      page.click_link 'Cancel'
    end

    def self.page
      Pages::Page.new(form_prefix: FORM_PREFIX)
    end
  end
end
