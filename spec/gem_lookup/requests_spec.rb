# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.describe GemLookup::Requests do
  subject(:instance) { described_class.new batch: batch_of_gems, json: json_in }

  let(:batch_of_gems) { [junk, junk, junk] }
  let(:json_in)       { nil }

  describe 'constants' do
    it 'has a timeout threshold, in seconds' do
      expect(described_class::TIMEOUT_THRESHOLD).to eq 10
    end
  end

  describe '.initialize' do
    let(:expected_vars) { %i[@batch @json] }

    it 'has the defined instance variables' do
      expect(instance.instance_variables).to eq expected_vars
    end
  end

  describe '#process' do
    let(:uri) { url batch_of_gems.first }

    context 'when the request is successful' do
      let(:batch_of_gems) { %w[rails] }
      let(:expected_json) do
        request_json.tap do |json|
          json[:exists] = true
          json[:timeout] = false
        end
      end

      before do
        stub_request(:get, uri).to_return(status: 200, body: request_content)
      end

      context 'when no JSON is passed in' do
        let(:json_in) { nil }

        it 'returns JSON with added gem data' do
          expect(instance.process[:gems].first).to eq expected_json
        end
      end

      context 'when basic JSON is passed in' do
        let(:json_in) { { gems: [] } }

        it 'returns JSON with added gem data' do
          expect(instance.process[:gems].first).to eq expected_json
        end
      end

      context 'with pre-existing JSON passed in' do
        let(:json_in)   { { gems: [fake_json] } }
        let(:fake_json) { simple_json junk, exists: false, timeout: false }

        it 'returns JSON with added gem data' do
          expect(instance.process[:gems][1]).to eq expected_json
        end
      end
    end

    context 'when request is unsuccessful' do
      let(:batch_of_gems) { [junk] }
      let(:expected_json) { simple_json batch_of_gems.first, exists: false, timeout: false }
      let(:failed_body)   { 'This rubygem could not be found.' }

      before do
        stub_request(:get, uri).to_return(status: 404, body: failed_body)
      end

      it 'returns JSON with that sets exists to false' do
        expect(instance.process[:gems].first).to eq expected_json
      end
    end

    context 'when the request times out' do
      let(:batch_of_gems) { [junk] }
      let(:expected_json) { simple_json batch_of_gems.first, exists: false, timeout: true }
      let(:failed_body)   { 'This rubygem could not be found.' }

      before do
        stub_request(:get, uri).to_timeout
      end

      it 'returns JSON with that sets timeout to true' do
        expect(instance.process[:gems].first).to eq expected_json
      end
    end
  end

  def simple_json(gem_name, exists:, timeout:)
    { name: gem_name, exists: exists, timeout: timeout }
  end

  def url(gem_name)
    "https://rubygems.org/api/v1/gems/#{gem_name}.json"
  end
end
# rubocop:enable Metrics/BlockLength
