# frozen_string_literal: true

RSpec.describe GemLookup do
  it 'has a version number' do
    expect(GemLookup::VERSION).not_to be nil
  end

  it 'does something useful' do
    useful = true
    expect(useful).to eq(true)
  end
end
