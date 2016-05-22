# Encapsulates how to build a URL for accessing the application
class UrlBuilder
  def self.url_for(url)
    base_url + url
  end

  def self.base_url
    ENV['QN_APP_HOST']
  end
end
