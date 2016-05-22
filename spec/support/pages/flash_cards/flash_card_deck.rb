module Pages
  #:nodoc:
  class FlashCardDeck < Page
    def initialize(quiz_id: nil)
      url = '/decks/'
      url += quiz_id if quiz_id.present?
      super(url: url)
    end

    def has_successful_save_message?
      has_success?('Deck was successfully saved')
    end

    def has_deck?(deck, tags)
      attribute?('Name:', deck.name) &&
        attribute?('Description:', deck.description) &&
        attribute?('Tags:', FlashCardDeck.formatted_tag_list(tags))
    end

    def click_decks_link
      click_link 'My Flash Decks'
      Pages::FlashCardDecks.new
    end

    def click_add_flash_card_link
      click_link 'Add Flash Card'
    end

    def add_flash_card(flash_card)
      fill_in 'front', with: flash_card.front
      fill_in 'back', with: flash_card.back
      select_by_value('flash_card_difficulty', flash_card.difficulty)
      click_button 'Save'
    end

    def has_flashcards?(flash_cards)
      flash_cards.each do |flash_card|
        return false unless has_flashcard?(flash_card)
      end
      true
    end

    def has_any_flashcards?
      !has_css?('td', text: 'No flash cards have been added yet.')
    end

    def self.formatted_tag_list(tags)
      tags.map { |t| t.name.strip.downcase }.sort.join(', ')
    end

    private

    def attribute?(field_title, field_value)
      title_cell = find('.field-title', text: field_title)
      parent_row = title_cell.parent
      within(parent_row) do
        return has_css?('td', text: field_value)
      end
    end

    def has_flashcard?(flash_card)
      within('table#flash-cards') do
        has_css?('td', text: flash_card.front) &&
          has_css?('td', text: flash_card.back)
      end
    end
  end
end
