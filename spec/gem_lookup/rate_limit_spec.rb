# frozen_string_literal: true

RSpec.describe GemLookup::RateLimit do
  it 'has a rate limit' do
    expect(described_class::MAX_REQUESTS_PER_SECOND).to eq 10
  end

  it 'has a documentation url' do
    url = 'https://guides.rubygems.org/rubygems-org-rate-limits/'
    expect(described_class::RATE_LIMIT_DOCUMENTATION_URL).to eq url
  end

  describe '.number' do
    subject(:number) { described_class.number }

    it 'returns the rate limit' do
      expect(number).to eq described_class::MAX_REQUESTS_PER_SECOND
    end
  end

  describe '.documentation_url' do
    subject(:documentation_url) { described_class.documentation_url }

    it 'returns the documentation url' do
      expect(documentation_url).to eq described_class::RATE_LIMIT_DOCUMENTATION_URL
    end
  end
end
