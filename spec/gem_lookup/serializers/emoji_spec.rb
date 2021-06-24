# frozen_string_literal: true

RSpec.describe GemLookup::Serializers::Emoji do
  describe '.display'
  describe '.gem_count'
  describe '.batch_iterator'
  describe '.querying'

  describe '.streaming?' do
    it 'returns true' do
      expect(described_class).to be_streaming
    end
  end
end
