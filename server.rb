require 'sinatra'
require_relative './models/url'
require_relative './services/counter_service'
require_relative './services/base62'

get '/' do
  'Hello, world!'
end

post '/shorten' do
  url = params[:url]

  halt 400, 'URL is required' unless url

  counter = CounterService.get_next_counter
  short_url = Base62.encode(counter)

  Url.create(short_url, url)

  content_type :json
  { short_url: short_url }.to_json
end

get '/:short_url' do
  short_url = params[:short_url]
  url_doc = Url.find_by_short_url(short_url)

  halt 404, 'URL not found' unless url_doc
  redirect url_doc[:original_url]
end
