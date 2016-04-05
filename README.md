# automated_web_test_demo

This is a demo of automated web testing, just for fun. It's a small sample of automated testing of just a slice of the functionality of a web application called Quiznerd.

I wrote Quiznerd using Ruby on Rails a while back. It's a web application that allows a user to create and use study aids like quizzes, flash card decks, etc. As part of development, I used the typical set of testing tools you'll see in use for a Rails app (RSpec, Capybara, Factory Girl, etc) to do unit tests as well as functional tests. I got to wondering .... could I use the same tools to perform the functional tests if it wasn't a Ruby on Rails application? The answer is yes with very few modifications, and here's the demo I wrote.

It does not assume anything about the implementation of the web application under test (i.e. it could be J2EE, Ruby on Rails, .NET, etc). In this case, the web application is Quiznerd which happens to be a Ruby on Rails app, but these techniques would work equally well on anything else. The only assumption is that it is a web application, and that you have access to the test database.

Notes:

* It uses RSpec as the testing framework. 
* For tests that use the web interface of Quiznerd, it uses 
  * RSpec's feature/scenario syntax, which is Cucumber-y.
  * Capybara (the acceptance test framework for web applications). 
  * Within Capybara, it is configured to use Selenium as the browser driver, with the default browser of Firefox. A quick config change could make it use a headless browser or still use Selenium but change the browser to Chrome, etc.
* For tests that use the API interface of Quiznerd, it uses RestClient to access the API.
* One of the assumptions is that you have access to the test database. This is for two reasons: 
  * make test data setup, whenever required, easier (insert data directly into the database, instead of via the browser, which is slower)
  * make clean up easier (delete directly from database after each test, instead of via browser).
* It uses the Database Cleaner gem for cleaning up the database after each test.
* It uses the ActiveRecord gem to make adding test data to the database easier. Again, there is no assumption that the application itself is written in Ruby, but if you're inserting data directly into the database for certain test scenarios, and you're using Ruby in your tests, why not use ActiveRecord? It makes it super easy. Of course you could write your own SQL, but we're shooting for quick, simple, and clean, so why would you?







