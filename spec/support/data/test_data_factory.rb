module TestDataFactory
  # Handles building and creating Flash Card Decks
  # in the Test database
  class TestDeck
    # Creating a flash card deck with a tag
    # involves writing to three tables:
    # 'decks', 'tags', and the join table 'taggings'
    def self.create(attributes, user)
      deck = Deck.create(
        name: attributes[:name],
        description: attributes[:description],
        user_id: user.id)
      tag = Tag.create(name: attributes[:tag_list])
      Tagging.create(
        tag_id: tag.id,
        taggable_id: deck.id,
        taggable_type: 'Deck')
      deck
    end

    def self.create_deck_for(user:, deck_number:)
      TestDataFactory::TestDeck.create(
        {
          name: "Deck number #{deck_number}",
          tag_list: 'decks',
          description: 'Test deck'
        },
        user)
    end
  end
end
