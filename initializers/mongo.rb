require_relative '../config/database'

module Collections
  def self.urls
    MongoDB.client[:urls]
  end
end
