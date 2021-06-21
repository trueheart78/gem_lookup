# frozen_string_literal: true

RSpec.describe Gem::Lookup do
  it 'has a version number' do
    expect(Gem::Lookup::VERSION).not_to be nil
  end

  it 'does something useful' do
    useful = false
    expect(useful).to eq(true)
  end
end
