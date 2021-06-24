# frozen_string_literal: true

RSpec.describe GemLookup::Flags do
  describe '.supported' do
    subject(:sorted_keys) { described_class.supported.keys.sort }

    it 'contains the expected keys' do
      expect(sorted_keys).to eq %i[help json version wordy]
    end

    describe 'help' do
      subject(:hash) { described_class.supported[:help] }

      let(:matches) { %w[-h --help] }
      let(:desc)    { 'Display the help screen.' }

      it 'has the expected matches' do
        expect(hash[:matches]).to eq matches
      end

      it 'has the expected description' do
        expect(hash[:desc]).to eq desc
      end
    end

    describe 'json' do
      subject(:hash) { described_class.supported[:json] }

      let(:matches) { %w[-j --json] }
      let(:desc)    { 'Bulk the output results as raw JSON.' }

      it 'has the expected matches' do
        expect(hash[:matches]).to eq matches
      end

      it 'has the expected description' do
        expect(hash[:desc]).to eq desc
      end
    end

    describe 'wordy' do
      subject(:hash) { described_class.supported[:wordy] }

      let(:matches) { %w[-w --wordy] }
      let(:desc)    { 'Stream the output using only words.' }

      it 'has the expected matches' do
        expect(hash[:matches]).to eq matches
      end

      it 'has the expected description' do
        expect(hash[:desc]).to eq desc
      end
    end

    describe 'version' do
      subject(:hash) { described_class.supported[:version] }

      let(:matches) { %w[-v --version] }
      let(:desc)    { 'Display version information.' }

      it 'has the expected matches' do
        expect(hash[:matches]).to eq matches
      end

      it 'has the expected description' do
        expect(hash[:desc]).to eq desc
      end
    end
  end

  describe '.supported?' do
    subject(:supported) { described_class.supported? type, flags: flags }

    let(:type)  { :help }
    let(:flags) { [] }

    context 'when passed a type that is supported' do
      let(:type)  { :help }

      context 'with a short flag that is supported' do
        let(:flags) { ['-h'] }

        it { is_expected.to be true }
      end

      context 'with a flag that is supported' do
        let(:flags) { ['--help'] }

        it { is_expected.to be true }
      end

      context 'with mixed flags where one is supported' do
        let(:flags) { ['--version', '-h', 'gem_name'] }

        it { is_expected.to be true }
      end

      context 'with mixed flags where none are supported' do
        let(:flags) { ['-v', '--json', 'gem_name'] }

        it { is_expected.to be false }
      end

      context 'with a flag that is not supported' do
        let(:flags) { ['--not-supported'] }

        it { is_expected.to be false }
      end
    end

    context 'when passed a type that is not supported' do
      context 'when the type is nil' do
        let(:type) { nil }

        it { is_expected.to eq false }
      end

      context 'when the type is not supported' do
        let(:type) { :not_supported }

        it { is_expected.to eq false }
      end

      context 'when the type is an empty string' do
        let(:type) { '' }

        it { is_expected.to eq false }
      end
    end

    context 'when passed an empty set of flags' do
      let(:flags) { [] }

      it { is_expected.to eq false }
    end
  end

  describe '.unsupported' do
    subject(:unsupported) { described_class.unsupported flags: flags }

    let(:flags) { [] }

    before do
      allow(described_class).to receive(:exit).with(1) { print 'exit(1)' }
    end

    context 'with a single flag' do
      let(:flags) { ['-x'] }
      let(:expected_output) do
        '=> Error: Unsupported flag [-x]'.red
      end

      it 'outputs the single flag' do
        output = capture_output { unsupported }.chomp

        expect(output).to start_with expected_output
      end

      it 'exits with an exit code of 1' do
        output = capture_output { unsupported }.chomp

        expect(output).to end_with 'exit(1)'
      end
    end

    context 'with multiple flags' do
      let(:flags) { ['-x', '--yes', '-b'] }
      let(:expected_output) do
        '=> Error: Unsupported flags [-x, --yes, -b]'.red
      end

      it 'outputs the flags' do
        output = capture_output { unsupported }.chomp

        expect(output).to start_with expected_output
      end

      it 'exits with an exit code of 1' do
        output = capture_output { unsupported }.chomp

        expect(output).to end_with 'exit(1)'
      end
    end

    context 'with multiple flags, some empty' do
      let(:flags) { ['-x', '', '--yes', nil,  '-b'] }
      let(:expected_output) do
        '=> Error: Unsupported flags [-x, --yes, -b]'.red
      end

      it 'outputs the non-empty flags' do
        output = capture_output { unsupported }.chomp

        expect(output).to start_with expected_output
      end

      it 'exits with an exit code of 1' do
        output = capture_output { unsupported }.chomp

        expect(output).to end_with 'exit(1)'
      end
    end

    context 'without any flags' do
      let(:flags) { [] }

      it 'returns false' do
        expect(unsupported).to eq false
      end

      it 'does not exit' do
        output = capture_output { unsupported }.chomp

        expect(output).to_not end_with 'exit(1)'
      end
    end
  end
end
