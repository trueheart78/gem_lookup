# frozen_string_literal: true

RSpec.describe 'rubocop analysis' do
  subject(:report) { `rubocop --config .rubocop.yml` }

  it 'has no offenses' do
    expect(report).to match(/no\ offenses\ detected/)
  end
end
