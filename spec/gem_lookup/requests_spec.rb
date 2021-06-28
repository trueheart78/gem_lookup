# frozen_string_literal: true

RSpec.describe GemLookup::Requests do
  subject(:instance) { described_class.new batch: batch_of_gems, json: json_in }

  let(:batch_of_gems) { [junk, junk, junk] }
  let(:json_in)       { nil }

  describe '.initialize' do
    let(:expected_vars) { %i[@batch @json] }

    it 'has the defined instance variables' do
      expect(instance.instance_variables).to eq expected_vars
    end
  end
end
