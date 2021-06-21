# frozen_string_literal: true

RSpec.describe GemLookup::Flags do
  describe '.supported' do
    subject (:sorted_keys) { described_class.supported.keys.sort }

    it 'contains the expected keys' do
      expect(sorted_keys).to eq %i[help json version]
    end

    describe 'help' do
      subject (:hash) { described_class.supported[:help] }

      let(:matches) { %w[-h --help] }
      let(:desc)    { 'Display the help screen.' }

      it 'has the expected matches' do
        expect(hash[:matches]).to eq matches
      end

      it 'has the expected description' do
        expect(hash[:desc]).to eq desc
      end
    end

    describe 'json' do
      subject (:hash) { described_class.supported[:json] }

      let(:matches) { %w[-j --json] }
      let(:desc)    { 'Display the raw JSON.' }

      it 'has the expected matches' do
        expect(hash[:matches]).to eq matches
      end

      it 'has the expected description' do
        expect(hash[:desc]).to eq desc
      end
    end

    describe 'version' do
      subject (:hash) { described_class.supported[:version] }

      let(:matches) { %w[-v --version] }
      let(:desc)    { 'Display version information.' }

      it 'has the expected matches' do
        expect(hash[:matches]).to eq matches
      end

      it 'has the expected description' do
        expect(hash[:desc]).to eq desc
      end
    end
  end

  describe '.supported?' do

  end
end
