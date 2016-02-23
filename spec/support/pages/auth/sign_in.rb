module Pages
  class SignIn
    include Capybara::DSL

    SIGN_IN_URL = '/users/sign_in'
    
    def sign_in(username: ENV["QN_USER"], password: ENV["QN_PASSWORD"])
      visit SIGN_IN_URL
      fill_in 'Email', with: username
      fill_in 'Password', with: password
      click_button 'Sign in'
    end

    def has_success_message?
      page.has_content? 'Signed in successfully'
    end

    def has_error_message?
      page.has_content? 'Invalid email or password'
    end
  end
end