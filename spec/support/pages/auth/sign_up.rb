module Pages
  # This class represents the Sign Up page of the application
  class SignUp
    URL = '/users/sign_up'

    def self.sign_up(username: ENV['QN_USER'], password: ENV['QN_PASSWORD'])
      page.sign_out if page.signed_in?

      page.visit URL
      page.fill_in 'Email', with: username
      page.fill_in 'Password', with: password
      page.fill_in 'Confirm', with: password
      page.click_button 'Sign up'
    end

    def self.has_success_message?
      page.has_alert?('Welcome! You have signed up successfully.')
    end

    def self.sign_out
      page.sign_out
    end

    def self.page
      Page.new
    end
  end
end
