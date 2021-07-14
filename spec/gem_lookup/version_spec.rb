# frozen_string_literal: true

RSpec.describe GemLookup do
  it 'has a version number' do
    expect(described_class::VERSION).not_to be nil
  end

  it 'has the expected name' do
    expect(described_class::NAME).to eq 'gem_lookup'
  end
end
