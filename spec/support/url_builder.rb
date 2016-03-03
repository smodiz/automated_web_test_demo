# Encapsulates how to build a URL for accessing the application
class UrlBuilder
  def self.url_for(url)
    ENV['QN_APP_HOST'] + url
  end
end
