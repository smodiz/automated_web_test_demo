# Automated Web Test Demo

This is a demo of automated web testing using Ruby and a selection of open source testing libraries available for Ruby. It demonstrates creating a framework to test a slice of the functionality of a web application called Quiznerd, both via the browser interface as well as via the API. 

Quiznerd is a web application I wrote that allows a user to create and use study aids like quizzes, flash cards, and cheatsheets. You can see it on Heroku [here](https://quiznerd.herokuapp.com). 

This automated testing framework does not not assume anything about the implementation of the web application under test (i.e. it could be J2EE, .NET, PHP, Ruby on Rails, etc). The only assumption is that it is a web application, and that you have access to the test database in order to programmatically insert test data directly into the database. 

### Page Object Design Pattern ###

This framework uses the Page Object design pattern. The Page Object pattern is a test automation pattern that aims to create an abstraction of your site's user interface that can be used in tests. The most common way to do this is to model each web page in your application as a class, and to then use those classes in your tests. Common elements like a header and a footer can be modeled as separate classes and can then be re-used by multiple Page classes. 

Developing your code in this way has several benefits. First of all, it just makes sense from an OO perspective to encapsulate knowledge of the structure of a web page in a single place. It makes it so that multiple tests that use the same web page can easily re-use the code that interacts with that page. It also means that when a developer changes the id of an element on a page and it breaks a bunch of your tests, you only have to change the code in one place and you know exactly where that place is!

Another benefit of developing your automated tests in this way is that you can more easily work in parallel with your development team. When using an Agile methodology this is especially important, since the test cycle is so short. 

You can create your skeleton page classes before the development team has created the actual pages, as long as both teams share the same understanding of how the functionality will be implemented (i.e. what pages will be developed, and what functionality will be available on each page). For instance, in the case where Quiznerd is going to allow a user to create flash card decks, we can create the FlashCardDeck page class even before the real page exists, and create all the needed methods, like 'click_add_flash_card_link'. The method won't do anything for now. You'll fill in the blanks when the page is developed and delivered, because it is only then that you will know for sure how to find that link on the page. But in the meantime, since your tests should only ever interact with your page classes, and not the actual application, you are free to write all the tests that use that page in their entirety. Obviously you can't execute them yet, but they can be fully coded. This isolates and minimizes the things that cannot be done until development is done. 

Example skeleton page class:

```
# This class represents the Flash Card Decks Index page
class FlashCardDecks

  def self.visit
    # visit the url, fill in later once we know what it is
  end

  def self.click_create_deck
    # fill in later when we know how to find the link on the page
  end

  def self.has_deck?(deck_name)
    # fill in later ...
  end

# etc etc
end
```
Once your skeleton page classes have been created, you should be able to completely write your tests.

```
feature 'User creates flash card deck' do

  scenario 'succeeds with valid data' do
    deck = FactoryGirl.build(:deck)
    tag = FactoryGirl.build(:tag)

    Pages::SignIn.sign_in
    Pages::FlashCardDecks.visit
    Pages::FlashCardDecks.click_create_deck
    Pages::NewFlashCardDeck.create(deck, [tag])

    expect(Pages::FlashCardDeck).to have_deck(deck, [tag])
    expect(Pages::FlashCardDeck).to have_successful_save_message
  end
```
To see the page classes that were written for this framework, see the files in the [spec/support/pages directory](https://github.com/smodiz/automated_web_test_demo/tree/master/spec/support/pages). 

Note that the page classes all use class methods instead of requiring the class to be instantiated. This was a choice based entirely on ease of use for the person writing the tests, who may or may not be a developer. It's easier to call 'Pages::SignIn.sign_in' instead of having to instantiate the class and then call 'sign_in' on the instance. And the fact that the classes are all designed not to contain state makes it a less dangerous choice than it might otherwise be. 

### Test Data Management ###

The strategy I'm using for managing test data involves the use of these open source tools/libraries:

  * Active Record as the ORM
  * Factory Girl - to create test data, in conjunction with Active Record
  * Faker - to generate unique and realistic test data for things like names, emails, phone numbers
  * Database Cleaner - to help remove test data at the end of each test

Directly inserting test data is a big win in terms of performance. Instead of creating the data for a test via the browser interface, which will be slow, you can directly insert the setup data for each test into the database and then delete it in the cleanup phase. 

For instance, if I have tests that exerise the search functionality for flash card decks, it would be slow to add the necessary decks and the associated flash cards via the browser. You're also going to want to remove the data at the end of the test, and if you are also doing that via the browser interface, your tests are going to take much, much longer to run. 

It is much faster to do this by programmatically inserting data directly into the database during the setup phase of a test. You could do this by writing SQL, or you could create some classes that represent your data and use an ORM to make it easier to interface to the database. For Ruby, the Active Record library is an ORM that provides an easy way to interact with a database with minimal code. Realllly minimal code!

____________________________

**Active Record**

Active Record requires that you create a class for each table in the database, and then interacting with that table is super easy via the class. Lets use the 'decks' table as an example. By convention, you would create the class 'Deck'. You don't even have to specify what attributes the Deck class has (i.e.  what columns the decks table has). Active Record will figure that out for you at run time and dynamically alter the class so that it has all the right attributes, like 'name' and 'description'.

You define the class like this:

```
class Deck < ActiveRecord::Base
end
```

That's all. How easy is that? Then somewhere in your test data factory, you could use it like this:

```
Deck.create(name: 'Design Patterns', description: 'From the Gang of Four book')
```

You can see all of the ActiveRecord classes for this project in the [models file]((https://github.com/smodiz/automated_web_test_demo/tree/master/spec/support/data/models.rb). 

____________________________

**Factory Girl and Faker**

In this framework, instead of creating a test data factory from scratch, I'm using Factory Girl. Factory Girl makes it easier and cleaner to create test data. It will use the Active Record classes we created, like the Deck class shown above. Factory Girl simplifies what we have to do because it will handle creating the related classes for a given entity, based on how we define the factory for it. For instance, lets say we need a pre-existing flash card for a test (like, say, for the 'delete a flash_card' test case). We can tell Factory Girl to create a flash card, and based on our configuration, it knows it needs to create a deck for that flash card to belong to, and also that it must associate that deck to a user, which can be a default user we set up, or one that we pass in to the factory when we call it. So instead of many lines of code to set up all of this test data, you can just say:

```
flash_card = FactoryGirl.create(:flash_card)
```
To see how a factory like the one above is defined, see [ the factories file](https://github.com/smodiz/automated_web_test_demo/tree/master/spec/support/data/factories.rb).

In adding to using Factory Girl to insert data into the database, we also use it to just create some data for us that we'll then feed to the browser to run our tests. This keeps most of the data issues out of our tests because very often when you run a test, you just want some data to work with and you don't much care what the data actually is. In this case, we can use Factory Girl's 'build' method. It creates an object with test data, but doesn't save it to the database.

```
flash_card = FactoryGirl.build(:flash_card)
``` 

For the cases where you DO care what one or more of the values are because of validation or boundary testing, just pass in the values that you care about and anything you don't care about will be automatically set to valid and reasonable values (according to the configuration you specified).

```
flash_card = FactoryGirl.build(:flash_card, front: 'i want this specific front of the card')
```

Simple and clean!

____________________________

**Database Cleaner**

And now, for the final part .... how do we get rid of the data after each test? That's where the Database Cleaner gem comes into play. 


### Test Runner ###

This uses RSpec as the testing framework. The main thing I like about RSpec is that it is a DSL with a clean and easy to read syntax. It looks more like English than code, which makes it a little more accessible to testers that don't have a lot of development experience. Before we look at a real example, let's look at the basic structure of a feature and scenario in RSpec. 

By convention, we separate the test setup, test execution, and checking the results by a blank line. This makes it easier to immediately identify what's going on (setup, or execution, or checking). 

```
feature 'some new feature' do
  before(:each) do
    # set up that applies to all scenarios
  end

  scenario 'does this under certain conditions' do
    # do setup that is specific only to this scenario

    # execute the test 

    # check the results
  end

  scenario 'another scenario' do
    # same structure as the 1st scenario
  end

  after(:each) do
    # if there's any teardown that applies to all scenarios
  end
end
```

Okay, now that we understand the structure, here's a real example. 

```
feature 'User creates flash card deck' do

  before(:each) do
    Pages::SignIn.sign_in
    Pages::FlashCardDecks.visit
    Pages::FlashCardDecks.click_create_deck
  end

  scenario 'succeeds with valid data' do
    # create some test data
    deck = FactoryGirl.build(:deck)
    tag = FactoryGirl.build(:tag)

    Pages::NewFlashCardDeck.create(deck, [tag])

    expect(Pages::FlashCardDeck).to have_deck(deck, [tag])
    expect(Pages::FlashCardDeck).to have_successful_save_message
  end

  scenario 'fails without required fields' do
    invalid_deck = FactoryGirl.build(:deck, name: '', description: '')
    Pages::NewFlashCardDeck.create(invalid_deck, [])

    expect(Pages::NewFlashCardDeck.page).to have_generic_page_error
    expect(Pages::NewFlashCardDeck.page).to have_required_field_message_for('name')
    expect(Pages::NewFlashCardDeck.page).to have_required_field_message_for('description')
  end

# etc etc
end
```

Note: by convention, we separate the test setup, test execution, and checking the results by a blank line. This makes it easier to immediately identify what a line of code is supposed to be doing (setup, or execution, or checking). 

```
  scenario 'it does something' do
    # do setup that is specific only to this scenario
    # (other setup that applies to all scenarios goes in the before(:each) section)

    # test the application

    # check the results
  end
```

In addition to the readability factor, I also like the fact that you can tag a test with one or more labels in RSpec. This allows you to tag a test as, say, 'smoke', or 'regression', or something else, and then run only the tests tagged a certain way. Even better, a single test can have multiple tags.

I also like the output options that RSpec provides. You can run it with minimal output and get the old familiar green dot for each passing test, or you can run it with a format of 'documentation', and get a more informative output, like this:

```
create flash card deck via the API
  with valid data
    successfully creates a flash card deck
  without required fields
    sends an error back for each missing required field

User creates flash card deck
  succeeds with valid data
  fails without required fields
  succeeds using an existing tag
  succeds using multiple tags
  succeeds using a tag containing special characters
  succeeds using a tag containing spaces
  doesn't create multiple tags when using duplicate tags names

Finished in 35.28 seconds (files took 1.11 seconds to load)
8 examples, 0 failures
```

You can even have it output HTML, which you can write to a file and view via a browser. 

There are also libraries that you can use to convert the RSpec output so that it is compatible with CI tools like Jenkins.

### Other Libraries/Tools Used ###

**Capybara**

Capybara is an acceptance test framework for web applications. It is a DSL for interacting with the browser. Why add this extra abstraction instead of just using Selenium directly? Here are some reasons:

* Capybara allows you to switch the browser driver you use without impacting your test code at all. In this project, Capybara is currently configured to use Selenium as the browser driver, with a default browser of Firefox. A quick config change could make it use the headless browser called webkit, or still use Selenium but change the browser to Chrome, etc. 

* One major source of trouble when running automated tests on a web application that uses Asynchronous Javascript calls (Ajax, etc) is the issue of timing. Your test might fail erroneously because it didn't find an element on the page yet. In reality, you need to wait a reasonable amount of time when testing this type of code. Capybara smartly handles the issue of waiting for elements to appear on the page for you, in an efficient way such that you're not waiting more than necessary. When using Selenium directly, you have to deal with that yourself.

* Capybara has a nicer API. Here's a comparison of doing the same thing in Capybara versus Selenium.

Selenium:

```
driver = Selenium::WebDriver.for(:firefox) 
driver.navigate.to("http://www.example.com") 
driver.find_element(:link, "Login Here").click
driver.quit

```

Capybara:

```
visit       "http://www.example.com"
click_link  "Login Here"
```

Capybara handles instantiating the driver, and stopping it afterwards, and it directs your commands to the driver without you having to prefix your commands with 'driver. It's just easier, cleaner, nicer. And if there's ever a case where the driver does something that Capybara doesn't support, Capybara will give you a handle to the driver and you can code away directly against whatever web driver you're using.

____________________________

**RestClient**

I'm using RestClient to access the API. 

You can see the API tests in the spec/api directory. These run super fast. There are two tests right now and they take about a tenth of a second to run.

See them [here](https://github.com/smodiz/automated_web_test_demo/blob/master/spec/api/v1/flash_cards/create_flash_card_deck_spec.rb) and [here](https://github.com/smodiz/automated_web_test_demo/blob/master/spec/api/v1/flash_cards/create_flash_card_spec.rb).

### Summary ###

Okay, we've seen how to set up a test automation framework using Ruby and various open source libraries available for Ruby. I think these tools are powerful and yet still easy to use.

To see all the example tests, look at the files in the [spec folder and sub-folders](https://github.com/smodiz/automated_web_test_demo/tree/master/spec).

Here is the output of the tests when run:

```
create flash card deck via the API
  with valid data
    successfully creates a flash card deck
  without required fields
    sends an error back for each missing required field

create flash card via the API
  with valid data
    successfully creates a flash card
  without required fields
    returns error for each missing required field

User Signs In
  signs you in with valid credentials
  does not sign you in with invalid username
  does not sign you in with invalid password

User creates flash card deck
  succeeds with valid data
  fails without required fields
  succeeds using an existing tag
  succeeds using multiple tags
  succeeds using a tag with special characters
  succeeds using a tag containing spaces
  doesn't create multiple tags when using duplicate tags names
  can cancel the operation successfully

user creates flash card
  succeeds with valid data
  fails with invalid fields
  succeeds with multiple cards

user views deck
  successfully views own decks
  cannot view other users deck

Finished in 1 minute 1.4 seconds (files took 1.06 seconds to load)
20 examples, 0 failures

```