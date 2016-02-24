module Pages
  #:nodoc:
  class Page
    include Capybara::DSL

    attr_reader :url

    def initialize(form_prefix: '', url:)
      @url = url
      @prefix = form_prefix
    end

    def visit
      super(url)
    end

    def has_alert?(message)
      has_css?(alert_css) && find(alert_css).has_content?(message)
    end

    def has_warning?(message)
      has_css?(warning_css) && find(warning_css).has_content?(message)
    end

    def has_error?(message)
      has_css?(error_css) && find(error_css).has_content?(message)
    end

    def has_success?(message)
      has_css?(success_css) && find(success_css).has_content?(message)
    end

    def has_generic_page_error?
      has_error?('Please review the problems below:')
    end

    def has_required_field_message_for?(field_name)
      within(".#{prefix}_#{field_name}") do
        has_css?('.help-block', text: "can't be blank")
      end
    end

    private

    attr_reader :prefix

    def alert_css
      'div.alert.alert-info'
    end

    def warning_css
      'div.alert.alert-warning'
    end

    def error_css
      'div.alert.alert-danger'
    end

    def success_css
      'div.alert.alert-success'
    end
  end
end
