# frozen_string_literal: true

RSpec.describe GemLookup::RubyGems do
  subject(:instance) { described_class.new cli_args }

  let(:cli_args) { [] }

  describe '.initialize' do
    let(:expected_vars) { %i[@gem_list @flags @display_mode @continue] }

    it 'has the defined instance variables' do
      expect(instance.instance_variables).to eq expected_vars
    end
  end

  describe '#find_all' do
    context 'with only gems' do
      let(:gems_instance) { instance_double 'GemLookup::Gems' }
      let(:display_mode)  { :emoji }
      let(:passed_gems)   { cli_args }

      before do
        allow(gems_instance).to receive(:process)
        allow(GemLookup::Gems).to receive(:new).with(passed_gems, display_mode: display_mode) do
          gems_instance
        end
      end

      context 'with any gems' do
        let(:cli_args) { [junk, junk, junk] }

        it 'calls the Gems#process with passed gems' do
          expect(gems_instance).to receive(:process).once
          instance.find_all
        end
      end

      context 'with duplicate gems' do
        let(:cli_args)    { %w(gem1 gem2 gem3 gem1) }
        let(:passed_gems) { cli_args.uniq }

        it 'calls the Gems#process with unique gems' do
          expect(gems_instance).to receive(:process).once
          instance.find_all
        end
      end

      context 'with varying-cased gems that include duplicates' do
        let(:cli_args)    { %w(Gem1 GEM_TWO gem3 gem1) }
        let(:passed_gems) { cli_args.map(&:downcase).uniq }

        it 'calls the Gems#process with lower-cased, unique gems' do
          expect(gems_instance).to receive(:process).once
          instance.find_all
        end
      end

      context 'with an unsupported display mode' do
        let(:cli_args)     { %w(gem) }
        let(:display_mode) { :unsupported }
        let(:error_start)  { "=> Error: Invalid display mode [#{display_mode}]".red }

        before do
          allow(gems_instance).to receive(:process).and_raise(GemLookup::Errors::InvalidDisplayMode, display_mode.to_s)
          allow(instance).to receive(:exit).with(1) { print 'exit(1)' }

          # private instance variable being changed for test case.
          instance.instance_variable_set :@display_mode, :unsupported
        end

        it 'displays an Invalid Display Mode error with an exit code of 1' do
          expect(gems_instance).to receive(:process).once
          output = capture_output { instance.find_all }

          expect(output).to start_with error_start
          expect(output).to end_with 'exit(1)'
        end
      end
    end

    context 'without any gems' do
      let(:gems_instance) { instance_double 'GemLookup::Gems' }
      let(:display_mode)  { :emoji }
      let(:passed_gems)   { cli_args }

      before do
        allow(gems_instance).to receive(:process)
        allow(GemLookup::Gems).to receive(:new).with(passed_gems, display_mode: display_mode) do
          gems_instance
        end
      end

      context 'when no gems are passed in' do
        let(:cli_args) { [] }

        before do
          allow(GemLookup::Help).to receive(:display).with(exit_code: 1) { puts "Help!\nexit(1)" }
        end

        it 'calls Help.display with an exit code of 1' do
          output = capture_output { instance.find_all }.chomp

          expect(output).to start_with 'Help!'
          expect(output).to end_with 'exit(1)'
        end

        it 'does not call Gems#process' do
          expect(gems_instance).to_not receive(:process)
          suppress_output { instance.find_all }
        end
      end

      context 'when only supported flags are passed in' do
        let(:cli_args) { ["-#{junk}", "-#{junk}", "-#{junk}"] }

        before do
          allow(GemLookup::Help).to receive(:display).with(exit_code: 1) { puts "Help!\nexit(1)" }
          allow(GemLookup::Flags).to receive(:unsupported) { false }
        end

        it 'calls Help.display with an exit code of 1' do
          output = capture_output { instance.find_all }.chomp

          expect(output).to start_with 'Help!'
          expect(output).to end_with 'exit(1)'
        end

        it 'does not call Gems#process' do
          expect(gems_instance).to_not receive(:process)
          suppress_output { instance.find_all }
        end
      end
    end

    context 'with flags' do
      let(:gems_instance) { instance_double 'GemLookup::Gems' }
      let(:display_mode)  { :emoji }
      let(:passed_gems)   { cli_args }

      before do
        allow(gems_instance).to receive(:process)
        allow(GemLookup::Gems).to receive(:new).with(passed_gems, display_mode: display_mode) do
          gems_instance
        end
      end

      context 'with a help flag' do
        let(:cli_args) { %w(--help) }

        before do
          %i[json version wordy].each do |type|
            allow(GemLookup::Flags).to receive(:supported?).with(type, flags: cli_args) { false }
          end
          allow(GemLookup::Flags).to receive(:supported?).with(:help, flags: cli_args)  { true }
          allow(GemLookup::Help).to receive(:display).with(exit_code: 0) { puts "Help!\nexit(0)" }
        end

        it 'calls Help.display with an exit code of 1' do
          expect(GemLookup::Help).to receive(:display).with(exit_code: 0)
          output = capture_output { instance.find_all }.chomp

          expect(output).to start_with 'Help!'
          expect(output).to end_with 'exit(0)'
        end
      end

      context 'with a version flag' do
        let(:cli_args) { %w(--version) }

        before do
          %i[help json wordy].each do |type|
            allow(GemLookup::Flags).to receive(:supported?).with(type, flags: cli_args)   { false }
          end
          allow(GemLookup::Flags).to receive(:supported?).with(:version, flags: cli_args) { true }
          allow(GemLookup::Help).to receive(:version).with(exit_code: 0) { puts "Version!\nexit(0)" }
        end

        it 'calls Help.display with an exit code of 1' do
          expect(GemLookup::Help).to receive(:version).with(exit_code: 0)
          output = capture_output { instance.find_all }.chomp

          expect(output).to start_with 'Version!'
          expect(output).to end_with 'exit(0)'
        end
      end

      context 'with a json flag and a gem' do
        let(:cli_args)     { flags + passed_gems }
        let(:flags)        { ["--#{display_mode}"] }
        let(:passed_gems)  { %w(gem) }
        let(:display_mode) { :json }

        before do
          %i[help version wordy].each do |type|
            allow(GemLookup::Flags).to receive(:supported?).with(type, flags: flags)   { false }
          end
          allow(GemLookup::Flags).to receive(:supported?).with(:json, flags: flags)    { true }
        end

        it 'calls Gems#process with an display mode of :json' do
          expect(gems_instance).to receive(:process).once
          instance.find_all
        end
      end

      context 'with a wordy flag' do
        let(:cli_args)     { flags + passed_gems }
        let(:flags)        { ["--#{display_mode}"] }
        let(:passed_gems)  { %w(gem) }
        let(:display_mode) { :wordy }

        before do
          %i[help json version].each do |type|
            allow(GemLookup::Flags).to receive(:supported?).with(type, flags: flags)   { false }
          end
          allow(GemLookup::Flags).to receive(:supported?).with(:wordy, flags: flags)    { true }
        end

        it 'calls Gems#process with an display mode of :wordy' do
          expect(gems_instance).to receive(:process).once
          instance.find_all
        end
      end

      context 'with an unsupported flag' do
        let(:cli_args)    { flags + passed_gems }
        let(:flags)       { %w(--unsupported_flag) }
        let(:passed_gems) { %w(gem) }
        let(:error_start) { "=> Error: Unsupported flag [#{flags.first}]".red }

        before do
          %i[help json wordy version].each do |type|
            allow(GemLookup::Flags).to receive(:supported?).with(type, flags: flags)   { false }
          end
          allow(GemLookup::Flags).to receive(:unsupported).with(flags: flags)
                                     .and_raise(GemLookup::Errors::UnsupportedFlag, flags.first)
          allow(instance).to receive(:exit).with(1) { print 'exit(1)' }
        end

        it 'displays an Unsupported Flag error with an exit code of 1' do
          output = capture_output { instance.find_all }

          expect(output).to start_with error_start
          expect(output).to end_with 'exit(1)'
        end
      end

      context 'with multiple unsupported flags' do
        let(:cli_args)    { flags + passed_gems }
        let(:flags)       { %w(--unsupported_flag -uf) }
        let(:passed_gems) { %w(gem) }
        let(:error_start) { "=> Error: Unsupported flags [#{flags.join(', ')}]".red }

        before do
          %i[help json wordy version].each do |type|
            allow(GemLookup::Flags).to receive(:supported?).with(type, flags: flags)   { false }
          end
          allow(GemLookup::Flags).to receive(:unsupported).with(flags: flags)
                                     .and_raise(GemLookup::Errors::UnsupportedFlags, flags.join(', '))
          allow(instance).to receive(:exit).with(1) { print 'exit(1)' }
        end

        it 'displays an Unsupported Flags error with an exit code of 1' do
          output = capture_output { instance.find_all }

          expect(output).to start_with error_start
          expect(output).to end_with 'exit(1)'
        end
      end
    end
  end
end
