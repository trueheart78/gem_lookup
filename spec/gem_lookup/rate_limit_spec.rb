# frozen_string_literal: true

RSpec.describe GemLookup::RateLimit do
  it 'has a rate limit' do
    expect(GemLookup::RateLimit::MAX_REQUESTS_PER_SECOND).to eq 10
  end
end
