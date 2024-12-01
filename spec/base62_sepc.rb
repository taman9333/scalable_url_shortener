require_relative '../services/base62'

RSpec.describe Base62 do
  describe '.encode' do
    it 'encodes 0 correctly' do
      expect(Base62.encode(0)).to eq('0')
    end

    it 'encodes single-digit numbers correctly' do
      expect(Base62.encode(5)).to eq('5')
    end

    it 'encodes numbers correctly into Base62' do
      expect(Base62.encode(10)).to eq('a')
      expect(Base62.encode(61)).to eq('Z')
      expect(Base62.encode(62)).to eq('10')
      expect(Base62.encode(3844)).to eq('100')
    end

    it 'raises an error for negative numbers' do
      expect { Base62.encode(-1) }.to raise_error(ArgumentError, 'Number must be non-negative')
    end
  end
end
