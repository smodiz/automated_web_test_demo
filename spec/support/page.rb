module Pages
  class Page
    include Capybara::DSL

    attr_reader :url

    def initialize(url)
      @url = url
    end

    def visit
      super(url)
    end

    def has_alert(message)
      find(alert_css).has_content?(message)
    end

    def has_warning(message)
      find(warning_css).has_content?(message)
    end

    def has_error(message)
      find(error_css).has_content?(message)
    end

    private 

    def alert_css
      'div.alert.alert-info'
    end

    def warning_css
      'div.alert.alert-warning'
    end

    def error_css
      'div.alert.alert-danger'
    end
  end
end
