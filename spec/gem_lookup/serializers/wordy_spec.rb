# frozen_string_literal: true

RSpec.describe GemLookup::Serializers::Wordy do
  describe '.display'
  describe '.gem_count' do
    subject(:gem_count) do
      capture_output { described_class.gem_count num }.chomp
    end

    let(:num)    { junk :int, min: 1, max: 1_000 }
    let(:output) { "=> Query: #{num} gems".light_cyan }

    it { is_expected.to eq output }
  end

  describe '.batch_iterator' do
    subject(:batch_iterator) do
      capture_output { described_class.batch_iterator num, total }.chomp
    end

    let(:num)    { junk :int, min: 1, max: 499 }
    let(:total)  { junk :int, min: 500, max: 1_000 }
    let(:output) { "=> Batch: #{num} of #{total}".yellow }

    it { is_expected.to eq output }
  end

  describe '.querying' do
    subject(:querying) do
      capture_output { described_class.querying batch }.chomp
    end

    let(:batch)  { [ junk, junk, junk, junk ] }
    let(:output) { "=> Looking up: #{batch.join(', ')}".light_yellow }

    it { is_expected.to eq output }
  end

  describe '.streaming?' do
    it 'returns true' do
      expect(described_class).to be_streaming
    end
  end
end
