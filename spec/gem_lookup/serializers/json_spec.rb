# frozen_string_literal: true

RSpec.describe GemLookup::Serializers::Json do
  describe '.display' do
    let(:expected_output) { '' }

    it 'prints out valid JSON' do
      json = capture_output { described_class.display json: junk }

      expect { JSON.parse json }.to_not raise_error
    end
  end

  describe '.streaming?' do
    it 'returns false' do
      expect(described_class).to_not be_streaming
    end
  end
end
