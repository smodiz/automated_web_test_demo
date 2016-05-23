module Pages
  # This class represents the Flash Card Decks Index page,
  # which lists all the Decks associated with the given user
  class FlashCardDecks
    URL = '/decks'

    def self.visit
      page.visit URL
    end

    def self.click_create_deck
      page.click_link 'New Flash Deck',  match: :first
    end

    def self.has_tags?(tag_list)
      tags = tag_list.split(',')
      tags.each do |tag_name|
        page.within('.tag-well') do
          page.has_css?('a', text: tag_name)
        end
      end
    end

    def self.has_no_decks?
      page.has_content? 'There are no flash card decks yet.'
    end

    def self.has_deck?(deck_name)
      page.has_link? deck_name
    end

    def self.click_deck_link(deck_name)
      page.click_link deck_name
    end

    def self.page
      Pages::Page.new
    end
  end
end
