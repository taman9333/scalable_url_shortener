require 'rack/cors'

module Cors
  def self.configure(app)
    app.use Rack::Cors do
      allow do
        origins 'http://localhost:8080' # FE
        resource '*',
                 headers: :any,
                 methods: [:get, :post, :put, :delete, :options]
      end
    end
  end
end
