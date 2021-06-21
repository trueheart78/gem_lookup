# frozen_string_literal: true

RSpec.describe GemLookup::Help do
  it 'has output spacing' do
    expect(described_class::OUTPUT_OPTION_SPACING).to eq 21
  end

  describe '.display' do
    context 'with no exit code' do
      it 'calls the .content method' do
        expect(described_class).to receive(:content)
        suppress_output { described_class.display }
      end
    end
  end

  describe '.content' do
    subject(:content) { described_class.content }

    let(:expected_content) do
      <<~CONTENT

       Usage: gems GEMS

         Retrieves gem-related information from https://rubygems.org

       Example: gems rails rspec

       This application's purpose is to make working with with RubyGems.org easier. 💖
       It uses the RubyGems public API to perform lookups, and parses the JSON response
       body to provide details about the most recent version, as well as links to
       the home page, source code, and changelog.

       Feel free to pass in as many gems that you like, as it makes requests in
       parallel. There is a rate limit, 10/sec. If it detects the amount of gems it
       has been passed is more than the rate limit, the application will run in Batch
       mode, and introduce a one second delay between batch lookups.

       Output Options:
         -h --help            Display the help screen.
         -j --json            Display the raw JSON.
         -v --version         Display version information.

       Rate limit documentation: https://guides.rubygems.org/rubygems-org-rate-limits/
      CONTENT
    end

    it 'is expected to be extensive' do
      expect(content).to eq expected_content
    end
  end
end
