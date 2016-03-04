module Pages
  #:nodoc:
  class Dashboard < Page
    def initialize
      super(url: '/')
    end
    # nothing needed from homepage yet, except the menu
    # component, which is provided by the superclass
  end
end
