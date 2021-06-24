# frozen_string_literal: true

RSpec.describe GemLookup::Serializers::Emoji do
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
    let(:output) { "=> 🤔 #{num} gems".light_cyan }

    it { is_expected.to eq output }
  end

  describe '.batch_iterator' do
    subject(:batch_iterator) do
      capture_output { described_class.batch_iterator num, total }.chomp
    end

    let(:num)    { junk :int, min: 1, max: 499 }
    let(:total)  { junk :int, min: 500, max: 1_000 }
    let(:output) { "=> 🧺 #{num} of #{total}".yellow }

    it { is_expected.to eq output }
  end

  describe '.querying' do
    subject(:querying) do
      capture_output { described_class.querying batch }.chomp
    end

    let(:batch)  { [ junk, junk, junk, junk ] }
    let(:output) { "=> 🔎 #{batch.join(', ')}".light_yellow }

    it { is_expected.to eq output }
  end

  describe '.streaming?' do
    it 'returns true' do
      expect(described_class).to be_streaming
    end
  end
end
