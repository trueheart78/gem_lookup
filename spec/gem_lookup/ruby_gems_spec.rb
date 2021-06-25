# frozen_string_literal: true

RSpec.describe GemLookup::RubyGems do
  subject(:instance) { described_class.new cli_args }

  let(:cli_args) { [] }

  describe '.initialize' do
    let(:expected_vars) { %i[@gem_list @flags @display_mode] }

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
    end

    context 'without any gems' do
      context 'when no gems are passed in' do

      end

      context 'when only flags are passed in' do

      end
    end

    context 'with flags' do
      context 'with a help flag' do
        # captures output and verifies the help method was called
      end

      context 'with a version flag' do
        # captures output and verifies the help method was called
      end

      context 'with a json flag' do

      end

      context 'with a wordy flag' do

      end

      context 'with an unsupported flag' do
        before do

        end
      end
    end
  end
end
