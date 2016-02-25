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

    def has_deck_with_attributes?(attributes)
      attribute?('Name:', attributes[:name]) &&
        attribute?('Description:', attributes[:description]) &&
        attribute?('Tags:', formatted_tag_list(attributes[:tag_list]))
    end

    def click_decks_link
      click_link 'My Flash Decks'
      Pages::FlashCardDecks.new
    end

    private

    def attribute?(field_title, field_value)
      title_cell = find('.field-title', text: field_title)
      parent_row = title_cell.parent
      within(parent_row) do
        return has_css?('td', text: field_value)
      end
    end

    def formatted_tag_list(tag_list)
      tag_list.split(',').map { |s| s.strip.downcase }.sort.join(', ')
    end
  end
end
