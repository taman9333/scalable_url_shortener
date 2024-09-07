require 'etcdv3'

COUNTER_KEY = 'url_shortener/counter'.freeze

class Etcd
  def self.client
    @client ||= begin
        Etcdv3.new(endpoints: ENV['ETCD_URL'])
      end
  end
end
