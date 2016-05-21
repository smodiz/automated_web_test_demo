# Using the Active Record library to help easily manage test data in the
# database. See the README file for more information.
#
# This is only a subset of the tables in the Quiznerd application
# because this automated test example only tests a subset of the
# functionality. For a large application each class would be
# located in a separate file to make things neater and easier to find.

# Table: users
class User < ActiveRecord::Base; end

# Table: decks
#
# See the comments on the Tagging class to understand the
# relationship between decks, taggings, and tags.
class Deck < ActiveRecord::Base
  belongs_to :user
  has_many :flash_cards, dependent: :destroy
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings
end

# Table: flash_cards
class FlashCards < ActiveRecord::Base
  belongs_to :deck
end

# Table: tags.
#
# A tag is used to label an entity. For instance, a flash card deck
# can be tagged with "ruby", to indicate that the subject matter of
# the deck relates to ruby.
#
# A tag can be associated with one or more entities via a
# tagging.
class Tag < ActiveRecord::Base
  has_many :taggings, dependent: :destroy
  has_many :decks,
           through: :taggings,
           source: :taggable,
           source_type: 'Deck'
end

# Table taggings.
#
# This is a many-to-many join table between tags and decks.
# Tags can also apply to other entities, like cheatsheets,
# so it is actually a polymorphic many-to-many relationship,
# and the name for the polymorphic entity is "taggable" (i.e a deck
# is "taggable", a cheatsheet is "taggable", etc). So technically, the
# first sentence should read: This is a many-to-many join table between
# tags and taggables.
class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :taggable, polymorphic: true
end
