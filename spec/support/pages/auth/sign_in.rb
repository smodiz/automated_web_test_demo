module Pages
  # This class represents the Sign In page
  class SignIn

    URL ='/users/sign_in'

    def self.sign_in(username: ENV['QN_USER'], password: ENV['QN_PASSWORD'])
      page = Page.new
      page.sign_out if page.signed_in?

      page.visit '/users/sign_in'
      page.fill_in 'Email', with: username
      page.fill_in 'Password', with: password
      page.check 'Remember me'
      page.click_button 'Sign in'
    end

    def self.has_success_message?
      page = Page.new
      page.has_alert?('Signed in successfully')
    end

    def self.has_error_message?
      page = Page.new
      page.has_warning?('Invalid email or password')
    end
  end
end
