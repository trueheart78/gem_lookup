# frozen_string_literal: true

RSpec.describe GemLookup::Gems do
  subject(:instance) { described_class.new gem_list, serializer: serializer }

  let(:batch)      { gem_list }
  let(:streamable) { true }
  let(:gem_list)   { [] }
  let(:json) do
    { gems: [] }
  end
  let(:serializer) do
    class_double('GemLookup::Serializers::Interface').tap do |s|
      allow(s).to receive(:display).with(json: json)
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
end
