module Pages
  #:nodoc:
  class SignUp < Page
    def initialize
      super(url: '/users/sign_up')
    end

    def sign_up(username: ENV['QN_USER'], password: ENV['QN_PASSWORD'])
      visit_page
      fill_in 'Email', with: username
      fill_in 'Password', with: password
      fill_in 'Confirm', with: password
      click_button 'Sign up'
    end

    def has_success_message?
      has_alert?('Welcome! You have signed up successfully.')
    end
  end
end
