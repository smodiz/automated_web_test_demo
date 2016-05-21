# Using Factory Girl to easily create test data. Factory Girl
# will use the Active Record classes defined the models.rb file
# to insert data into the right tables. In some cases, we are using
# the Faker gem to create realistic data that is unique as well as
# valid, like in the case of a user's email address and password. In
# other cases, the sequence method is used to add a sequential
# number to a field to make it unique, like for the front and back
# of a flash card.

# For a larger application, you would split each factory or
# set of related factories into separate files to make it
# more manageable and easier to find things.

# The values contained here for each factory are default
# values that can be over-ridden as needed when creating
# test data.
# For example, this creates the default:
#  FactoryGirl.create(:user)
#
# This creates one with a specific email and default values for everything else:
#  FactoryGirl.create(:user, email: 'something-specific@example.com')
#
FactoryGirl.define do
  factory :user do
    email Faker::Internet.email
    password Faker::Internet.password(8)
    password_confirmation "#{password}"
  end

  factory :deck, aliases: [:taggable] do
    sequence(:name) { |n| "Flash Deck #{n}" }
    description { "Description for #{name}" }
    user_id { User.where(email: ENV['QN_USER']) }
    status 'Private'
  end

  factory :flash_card do
    sequence(:front) { |n| "Front of flash card #{n}" }
    sequence(:back) { |n| "Back of flash card #{n}" }
    difficulty { %w(1 2 3).sample }
  end

  factory :tag do
    sequence(:name) { |n| "tag-#{n}" }
  end

  factory :tagging do
    association :tag, factory: :tag
    association :taggable, factory: :deck
    taggable_type 'Deck'
  end
end


