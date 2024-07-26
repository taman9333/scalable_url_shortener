class Url
  def self.find_by_short_url(short_url)
    URLS_COLLECTION.find(short_url: short_url).first
  end

  def self.create(short_url, original_url)
    URLS_COLLECTION.insert_one({ short_url: short_url, original_url: original_url })
  end
end
