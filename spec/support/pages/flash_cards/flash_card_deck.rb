module Pages
  #:nodoc:
  class FlashCardDeck
    URL = '/decks/'

    def self.has_successful_save_message?
      page.has_success?('Deck was successfully saved')
    end

    def self.has_deck?(deck, tags)
      attribute?('Name:', deck.name) &&
        attribute?('Description:', deck.description) &&
        attribute?('Tags:', FlashCardDeck.formatted_tag_list(tags))
    end

    def self.click_decks_link
      page.click_link 'My Flash Decks'
    end

    def self.click_add_flash_card_link
      page.click_link 'Add Flash Card'
    end

    def self.add_flash_card(flash_card)
      page.fill_in 'front', with: flash_card.front
      page.fill_in 'back', with: flash_card.back
      page.select_by_value('flash_card_difficulty', flash_card.difficulty)
      page.click_button 'Save'
    end

    def self.has_flashcards?(flash_cards)
      flash_cards.each do |flash_card|
        return false unless has_flashcard?(flash_card)
      end
      true
    end

    def self.has_any_flashcards?
      !page.has_css?('td', text: 'No flash cards have been added yet.')
    end

    def self.formatted_tag_list(tags)
      tags.map { |t| t.name.strip.downcase }.sort.join(', ')
    end

    def self.attribute?(field_title, field_value)
      title_cell = page.find('.field-title', text: field_title)
      parent_row = title_cell.parent
      page.within(parent_row) do
        return page.has_css?('td', text: field_value)
      end
    end

    def self.has_flashcard?(flash_card)
      page.within('table#flash-cards') do
        page.has_css?('td', text: flash_card.front) &&
          page.has_css?('td', text: flash_card.back)
      end
    end

    def self.page
      Pages::Page.new
    end
  end
end
