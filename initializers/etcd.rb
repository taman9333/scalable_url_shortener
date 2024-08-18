require 'etcdv3'

ETCD_CLIENT = Etcdv3.new(endpoints: ENV['ETCD_URL'])
COUNTER_KEY = 'url_shortener/counter'.freeze
