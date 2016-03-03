module TestDataFactory
  # Handles building and creating Flash Card Decks
  # in the Test database
  class TestDeck
    # Creating a flash card deck with a tag
    # involves writing to three tables:
    # 'decks', 'tags', and the join table 'taggings'
    def create(attributes, user)
      deck = Deck.create(
        name: attributes[:name],
        description: attributes[:description],
        user_id: user.id)
      tag = Tag.create(name: attributes[:tag_list])
      Tagging.create(
        tag_id: tag.id,
        taggable_id: deck.id,
        taggable_type: 'Deck')
    end
  end
end
