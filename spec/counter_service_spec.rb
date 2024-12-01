require_relative '../services/counter_service'
require 'etcdv3'

RSpec.describe CounterService do
  let(:mock_etcd_client) { instance_double(Etcdv3) }
  let(:mock_etcd_response) { instance_double('Etcdv3::RangeResponse') }
  let(:counter_key) { 'counter_key' }
  let(:initial_counter_value) { 0 }
  let(:range_size) { CounterService::RANGE_SIZE }

  before do
    allow(Etcd).to receive(:client).and_return(mock_etcd_client)
    allow(mock_etcd_client).to receive(:get).with(counter_key).and_return(mock_etcd_response)
    allow(mock_etcd_response).to receive(:kvs).and_return([double(value: initial_counter_value.to_s)])
    allow(mock_etcd_client).to receive(:transaction) do |&block|
      new_value = initial_counter_value + range_size
      allow(mock_etcd_response).to receive(:kvs).and_return([double(value: new_value.to_s)])
      instance_double('Etcdv3::TransactionResponse', succeeded: true)
    end
    stub_const('CounterService::COUNTER_KEY', counter_key)
  end

  describe '.initialize_counter_range' do
    it 'initializes counter range and counter' do
      CounterService.initialize_counter_range
      expect(CounterService.send(:counter_range)).to eq(initial_counter_value...(initial_counter_value + range_size))
      expect(CounterService.send(:counter)).to eq(initial_counter_value)
    end
  end

  describe '.get_next_counter' do
    before do
      CounterService.initialize_counter_range
    end

    it 'returns the next counter value' do
      initial_counter = CounterService.send(:counter)
      expect(CounterService.get_next_counter).to eq(initial_counter)
    end

    it 'increments the counter value' do
      initial_counter = CounterService.get_next_counter
      next_counter = CounterService.get_next_counter
      expect(next_counter).to eq(initial_counter + 1)
    end

    it 'fetches a new counter range when the current range is exhausted' do
      CounterService.send(:counter=, CounterService.send(:counter_range).last)
      new_counter = CounterService.get_next_counter
      expect(new_counter).to eq(CounterService.send(:counter_range).first)
    end
  end
end
