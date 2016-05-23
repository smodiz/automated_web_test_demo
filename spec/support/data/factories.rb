
require_relative 'models'
# Using Factory Girl to easily create test data. Factory Girl
# will use the Active Record classes defined the models.rb file
# to insert data into the right tables. We can either use
# the Faker gem to create realistic data that is unique as well as
# valid, like in the case of a user's email address and password, or
# we can use the sequence method to add a sequential number to a field
# to make it unique, like for the front and back of a flash card.

# For a larger application, you would split each factory or
# set of related factories into separate files to make it
# more manageable and easier to find things.

# The values contained here for each factory are default
# values that can be over-ridden as needed when creating
# test data.
# For example, this creates the default:
#  FactoryGirl.create(:flash_card)
#
# This creates one with a specific front and default values for everything else:
#  FactoryGirl.create(:flash_card, front: 'This is the front')
#
FactoryGirl.define do
  factory :deck, aliases: [:taggable] do
    sequence(:name) { |n| "Flash Deck #{n}" }
    description { "Description for #{name}" }
    user_id { User.where(email: ENV['QN_USER']).first.id }
    status 'Private'
  end

  factory :flash_card do
    sequence(:front) { |n| "Front of flash card #{n}" }
    sequence(:back) { |n| "Back of flash card #{n}" }
    difficulty { %w(1 2 3).sample }
    sequence(:sequence) { |n| "#{n}" }
    association :deck, factory: :deck
  end

  # See the models.rb file to understand the relationship between decks and tags. It 
  # is a polymorphic many-to-many relationship.
  factory :tag do
    sequence(:name) { |n| "tag-#{n}" }
  end

  factory :tagging do
    association :tag, factory: :tag
    association :taggable, factory: :deck
    taggable_type 'Deck'
  end
end


