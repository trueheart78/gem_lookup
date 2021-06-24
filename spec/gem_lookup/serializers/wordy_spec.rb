# frozen_string_literal: true

RSpec.describe GemLookup::Serializers::Wordy do
  describe '.display' do
    context 'with everything present'
    context 'with a missing source_code_uri'
    context 'with an empty source_code_uri'
    context 'with a missing changelog_uri'
    context 'with an empty changelog_ur'
    context 'with a missing mailing_list_uri'
    context 'with an empty mailing_list_uri'
    context 'when the gem does not exist'
  end

  describe '.gem_count' do
    subject(:gem_count) do
      capture_output { described_class.gem_count num }.chomp
    end

    let(:num)    { junk :int, min: 1, max: 1_000 }
    let(:output) { "=> Query: #{num} gems".light_cyan }

    it 'outputs the Query with the number of gems (light cyan)' do
      expect(gem_count).to eq output
    end
  end

  describe '.batch_iterator' do
    subject(:batch_iterator) do
      capture_output { described_class.batch_iterator num, total }.chomp
    end

    let(:num)    { junk :int, min: 1, max: 499 }
    let(:total)  { junk :int, min: 500, max: 1_000 }
    let(:output) { "=> Batch: #{num} of #{total}".yellow }

    it 'outputs the Batch with the current number of total batches (yellow)' do
      expect(batch_iterator).to eq output
    end
  end

  describe '.querying' do
    subject(:querying) do
      capture_output { described_class.querying batch }.chomp
    end

    let(:batch)  { [ junk, junk, junk, junk ] }
    let(:output) { "=> Looking up: #{batch.join(', ')}".light_yellow }

    it 'outputs Looking Up with the gems in the current batch (light yellow)' do
      expect(querying).to eq output
    end
  end

  describe '.streaming?' do
    it 'returns true' do
      expect(described_class).to be_streaming
    end
  end
end
