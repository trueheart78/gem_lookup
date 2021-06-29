# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.describe GemLookup::Gems do
  subject(:instance) { described_class.new gem_list, serializer: serializer }

  before do
    allow(GemLookup::RateLimit).to receive(:number).and_return(rate_limit)
    allow(GemLookup::RateLimit).to receive(:interval).and_return(0)
  end

  let(:batch)      { gem_list }
  let(:streamable) { true }
  let(:gem_list)   { [] }
  let(:rate_limit) { 10 }
  let(:json) do
    { gems: [] }
  end
  let(:serializer) do
    class_double('GemLookup::Serializers::Interface').tap do |s|
      allow(s).to receive(:display) # .with(json: json)
      allow(s).to receive(:gem_count).with(num: gem_list.size)
      allow(s).to receive(:batch_iterator).with(num: 1, total: 2)
      allow(s).to receive(:batch_iterator).with(num: 2, total: 2)
      allow(s).to receive(:querying).with(batch: batch)
      allow(s).to receive(:streaming?).and_return(streamable)
    end
  end

  describe '.initialize' do
    let(:expected_vars) { %i[@gem_list @serializer @batches @json] }

    it 'has the defined instance variables' do
      expect(instance.instance_variables).to eq expected_vars
    end
  end

  describe '#process' do
    before do
      processed_json[:gems] += gem_json
      allow(requests_instance).to receive(:process).and_return(processed_json)
      allow(GemLookup::Requests).to receive(:new).with(batch: batch, json: json) do
        requests_instance
      end
    end

    let(:requests_instance) { instance_double 'GemLookup::Requests' }
    let(:processed_json) do
      { gems: [] }
    end

    context 'with one gem' do
      let(:gem_list) { random_gem_list }
      let(:gem_json) { random_json_array }

      context 'with a streamable serializer' do
        let(:streamable) { true }

        it 'does call serializer.display' do
          expect(serializer).to receive(:display).once
          instance.process
        end

        it 'does not call serializer.gem_count' do
          expect(serializer).not_to receive(:gem_count)
          instance.process
        end
      end

      context 'with a bulk serializer' do
        let(:streamable) { false }

        it 'does call serializer.display' do
          expect(serializer).to receive(:display).once
          instance.process
        end

        it 'does not call serializer.querying' do
          expect(serializer).not_to receive(:querying)
          instance.process
        end
      end
    end

    context 'with a number of gems less than the rate limit' do
      let(:gem_list) { random_gem_list num: rate_limit - 1 }
      let(:gem_json) { random_json_array num: rate_limit - 1 }

      context 'with a streamable serializer' do
        let(:streamable) { true }

        it 'does call serializer.display multiple times' do
          expect(serializer).to receive(:display).exactly(gem_list.size).times
          instance.process
        end

        it 'does call serializer.gem_count' do
          expect(serializer).to receive(:gem_count).once
          instance.process
        end

        it 'does not call serializer.batch_iterator' do
          expect(serializer).not_to receive(:batch_iterator)
          instance.process
        end
      end

      context 'with a bulk serializer' do
        let(:streamable) { false }

        it 'does call serializer.display once' do
          expect(serializer).to receive(:display).once
          instance.process
        end

        it 'does not call serializer.querying' do
          expect(serializer).not_to receive(:querying)
          instance.process
        end
      end
    end

    context 'with a number of gems greater than the rate limit' do
      context 'with a streamable serializer' do
        let(:streamable) { true }

        xit 'processes as a stream'
      end

      context 'with a bulk serializer' do
        let(:streamable) { false }

        xit 'processes as bulk'
      end
    end
  end

  def random_gem_list(num: 1)
    [].tap do |array|
      num.times do
        array << junk
      end
    end
  end

  def random_json_array(num: 1)
    [].tap do |array|
      num.times do
        array << { name: junk, exists: true, timeout: false }
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
