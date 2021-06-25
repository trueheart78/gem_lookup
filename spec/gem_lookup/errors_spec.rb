# frozen_string_literal: true

RSpec.describe GemLookup::Errors do
  describe 'InvalidDisplayMode' do
    subject(:definition) { defined? described_class::InvalidDisplayMode }

    it 'is defined as a constant' do
      expect(definition).to eq 'constant'
    end
  end

  describe 'UnsupportedFlag' do
    subject(:definition) { defined? described_class::UnsupportedFlag }

    it 'is defined as a constant' do
      expect(definition).to eq 'constant'
    end
  end

  describe 'UnsupportedFlags' do
    subject(:definition) { defined? described_class::UnsupportedFlags }

    it 'is defined as a constant' do
      expect(definition).to eq 'constant'
    end
  end
end
