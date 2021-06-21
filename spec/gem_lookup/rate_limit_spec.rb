# frozen_string_literal: true

RSpec.describe GemLookup::RateLimit do
  it 'has a rate limit' do
    expect(described_class::MAX_REQUESTS_PER_SECOND).to eq 10
  end

  it 'has a documentation url' do
    url = 'https://guides.rubygems.org/rubygems-org-rate-limits/'
    expect(described_class::RATE_LIMIT_DOCUMENTATION_URL).to eq url
  end
end
