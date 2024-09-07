require_relative '../initializers/mongo'

class Url
  def self.find_by_short_url(short_url)
    Collections.urls.find(short_url: short_url).first
  end

  def self.create(short_url, original_url)
    Collections.urls.insert_one({ short_url: short_url, original_url: original_url })
  end
end
