# frozen_string_literal: true

RSpec.describe GemLookup::Serializers::Emoji do
  describe '.display' do
    subject(:display) do
      capture_output { described_class.display json: json }.chomp
    end

    context 'with everything present'
    context 'with a missing source_code_uri'
    context 'with an empty source_code_uri'
    context 'with a missing changelog_uri'
    context 'with an empty changelog_ur'
    context 'with a missing mailing_list_uri'
    context 'with an empty mailing_list_uri'
    context 'when the gem does not exist' do
      let(:json)   { serializer_json(:not_found)[:gems].first }
      let(:output) { '=> 💎 not_found not found'.red }

      it 'outputs the gem is not found (red)' do
        expect(display).to eq output
      end
    end
  end

  describe '.gem_count' do
    subject(:gem_count) do
      capture_output { described_class.gem_count num }.chomp
    end

    let(:num)    { junk :int, min: 1, max: 1_000 }
    let(:output) { "=> 🤔 #{num} gems".light_cyan }

    it 'outputs a thinking emoji with the number of gems (light cyan)' do
      expect(gem_count).to eq output
    end
  end

  describe '.batch_iterator' do
    subject(:batch_iterator) do
      capture_output { described_class.batch_iterator num, total }.chomp
    end

    let(:num)    { junk :int, min: 1, max: 499 }
    let(:total)  { junk :int, min: 500, max: 1_000 }
    let(:output) { "=> 🧺 #{num} of #{total}".yellow }

    it 'outputs a basket emoji with the current number of total batches (yellow)' do
      expect(batch_iterator).to eq output
    end
  end

  describe '.querying' do
    subject(:querying) do
      capture_output { described_class.querying batch }.chomp
    end

    let(:batch)  { [ junk, junk, junk, junk ] }
    let(:output) { "=> 🔎 #{batch.join(', ')}".light_yellow }

    it 'outputs a magnifying glass emoji with the gems in the current batch (light yellow)' do
      expect(querying).to eq output
    end
  end

  describe '.streaming?' do
    it 'returns true' do
      expect(described_class).to be_streaming
    end
  end
end
