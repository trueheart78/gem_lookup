# frozen_string_literal: true

RSpec.describe GemLookup::Serializers::Json do
  describe '.streaming?' do
    it 'returns false' do
      expect(described_class).to_not be_streaming
    end
  end
end
