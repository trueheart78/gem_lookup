# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.describe GemLookup::Serializers::Interface do
  let(:error_type) { GemLookup::Errors::UndefinedInterfaceMethod }

  describe '.display' do
    let(:message) { 'Class method .display with params (:json) must be implemented by sub-class' }

    it 'raises the expected "must be implemented by sub-class" error' do
      expect { described_class.display(json: []) }.to raise_error(error_type).with_message(message)
    end
  end

  describe '.gem_count' do
    let(:message) { 'Class method .gem_count with params (:num) must be implemented by sub-class' }

    it 'raises the expected "must be implemented by sub-class" error' do
      expect { described_class.gem_count(num: 1) }.to raise_error(error_type).with_message(message)
    end
  end

  describe '.batch_iterator' do
    let(:message) do
      'Class method .batch_iterator with params (:num, :total) must be implemented by sub-class'
    end

    it 'raises the expected "must be implemented by sub-class" error' do
      expect do
        described_class.batch_iterator(num: 1, total: 2)
      end.to raise_error(error_type).with_message(message)
    end
  end

  describe '.querying' do
    let(:message) { 'Class method .querying with params (:batch) must be implemented by sub-class' }

    it 'raises the expected "must be implemented by sub-class" error' do
      expect do
        described_class.querying(batch: [])
      end.to raise_error(error_type).with_message(message)
    end
  end

  describe '.streaming?' do
    let(:message) { 'Class method .streaming? must be implemented by sub-class' }

    it 'raises the expected "must be implemented by sub-class" error' do
      expect { described_class.streaming? }.to raise_error(error_type).with_message(message)
    end
  end
end
# rubocop:enable Metrics/BlockLength
