# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.describe GemLookup::Help do
  it 'has output spacing' do
    expect(described_class::OUTPUT_OPTION_SPACING).to eq 21
  end

  describe '.display' do
    context 'with no exit code' do
      it 'calls the .documentation method' do
        expect(described_class).to receive(:documentation)
        suppress_output { described_class.display exit_code: nil }
      end
    end
  end

  describe '.version' do
    before do
      allow(described_class).to receive(:exit).with(1) { print 'exit(1)' }
      allow(described_class).to receive(:exit).with(0) { print 'exit(0)' }
    end

    let(:content) do
      capture_output { described_class.version exit_code: exit_code }.chomp
    end

    context 'with an exit code of nil' do
      let(:exit_code) { nil }

      it 'outputs the gem name' do
        expect(content).to start_with GemLookup::NAME
      end

      it 'outputs the version' do
        expect(content).to include GemLookup::VERSION
      end

      it 'does not exit' do
        expect(content).not_to end_with 'exit(0)'
        expect(content).not_to end_with 'exit(1)'
      end
    end

    context 'with an exit code of 0' do
      let(:exit_code) { 0 }

      it 'outputs the gem name' do
        expect(content).to start_with GemLookup::NAME
      end

      it 'outputs the version' do
        expect(content).to include GemLookup::VERSION
      end

      it 'exits with an exit code of 0' do
        expect(content).to end_with 'exit(0)'
      end
    end

    context 'with an exit code of 1' do
      let(:exit_code) { 1 }

      it 'outputs the gem name' do
        expect(content).to start_with GemLookup::NAME
      end

      it 'outputs the version' do
        expect(content).to include GemLookup::VERSION
      end

      it 'exits with an exit code of 1' do
        expect(content).to end_with 'exit(1)'
      end
    end
  end

  describe '.documentation' do
    subject(:documentation) { described_class.documentation }

    let(:expected_documentation) do
      <<~DOCUMENTATION

        Usage: gems [OPTIONS] GEMS

          Retrieves gem-related information from https://rubygems.org

        Example: gems -j rails rspec

        This application's purpose is to make working with with RubyGems.org easier. 💖
        It uses the RubyGems public API to perform lookups, and parses the JSON response
        body to provide details about the most recent version, as well as links to
        the home page, source code, changelog, and mailing list.

        Feel free to pass in as many gems that you like, as it makes requests in
        parallel. There is a rate limit, 10/sec. If it detects the amount of gems it
        has been passed is more than the rate limit, the application will run in Batch
        mode, and introduce a one second delay between batch lookups.

        Output Options:
          -h --help            Display the help screen.
          -j --json            Bulk the output results as raw JSON.
          -v --version         Display version information.
          -w --wordy           Stream the output using only words.

        Rate limit documentation: https://guides.rubygems.org/rubygems-org-rate-limits/
      DOCUMENTATION
    end

    it 'is the expected documentation' do
      expect(documentation).to eq expected_documentation
    end
  end
end
# rubocop:enable Metrics/BlockLength
