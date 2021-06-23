# frozen_string_literal: true

RSpec.describe GemLookup::Errors do
  describe 'InvalidDisplayMode' do
    subject(:definition) { defined? described_class::InvalidDisplayMode }

    it 'is defined as a constant' do
      expect(definition).to eq 'constant'
    end
  end
end
