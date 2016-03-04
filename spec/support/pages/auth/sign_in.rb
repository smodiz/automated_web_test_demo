module Pages
  #:nodoc:
  class SignIn < Page
    def initialize
      super(url: '/users/sign_in')
    end

    def sign_in(username: ENV['QN_USER'], password: ENV['QN_PASSWORD'])
      sign_out if signed_in?

      visit_page
      fill_in 'Email', with: username
      fill_in 'Password', with: password
      click_button 'Sign in'
      Pages::Dashboard.new
    end

    def has_success_message?
      has_alert?('Signed in successfully')
    end

    def has_error_message?
      has_warning?('Invalid email or password')
    end
  end
end
