# frozen_string_literal: true

RSpec.describe GemLookup::Serializers::Json do
  describe '.display' do
    let(:expected_output) { '' }

    it 'prints out valid JSON' do
      json = capture_output { described_class.display json: junk }

      expect { JSON.parse json }.not_to raise_error
    end
  end

  describe '.streaming?' do
    it 'returns false' do
      expect(described_class).not_to be_streaming
    end
  end
end
