module Pages
  #:nodoc:
  class Dashboard
    URL = '/'

    def self.visit
      page.visit
    end

    def self.sign_out
      page.sign_out
    end

    def self.page
      Page.new
    end
  end
end
