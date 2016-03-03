module Pages
  #:nodoc:
  class FlashCardDecks < Page
    def initialize
      super(url: '/decks')
    end

    def click_create_deck
      click_link 'New Flash Deck',  match: :first
      Pages::NewFlashCardDeck.new
    end

    def has_tags?(tag_list)
      tags = tag_list.split(',')
      tags.each do |tag_name|
        within('.tag-well') do
          has_css?('a', text: tag_name)
        end
      end
    end

    def has_deck?
      !(has_content? 'There are no flash card decks yet.')
    end

    def click_deck_link(deck_name)
      click_link deck_name
      Pages::FlashCardDeck.new
    end
  end
end
