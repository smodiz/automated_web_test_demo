module TestDataFactory
  # Handles building and creating Flash Card Decks
  # in the Test database
  class TestDeck
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
