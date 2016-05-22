module Pages
  #:nodoc:
  class Page
    include Capybara::DSL

    attr_reader :url, :menu

    def initialize(form_prefix: '', url:)
      @url = url
      @prefix = form_prefix
      @menu = Components::Menu.new(self)
    end

    def visit_page
      visit(url)
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

    def signed_in?
      menu.signed_in?
    end

    def sign_out
      menu.sign_out
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

    def select_by_value(id, value)
      option = select_option_label(id, value)
      select(option, from: id)
    end

    def select_option_label(id, value)
      option_xpath = "//*[@id='#{id}']/option[@value='#{value}']"
      find(:xpath, option_xpath).text
    end
  end
end
