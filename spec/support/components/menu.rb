module Components
  #:nodoc:
  class Menu < Component
    attr_reader :page

    def initialize(page)
      @page = page
    end

    def sign_out
      click_link 'Account'
      click_link 'Sign out'
    end

    def home
      visit UrlBuilder.base_url
    end

    def signed_in?
      has_link? 'Account'
    end
  end
end
