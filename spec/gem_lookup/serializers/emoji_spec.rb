# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.describe GemLookup::Serializers::Emoji do
  describe '.display' do
    subject(:display) do
      capture_output { described_class.display json: json }.chomp
    end

    context 'with everything present' do
      let(:json)   { serializer_json(:rails)[:gems].first }
      let(:output) do
        <<~OUTPUT.chomp
          #{"=> 💎 rails is at 6.1.3.2".green}
          ==> 📅 May 5, 2021
          ==> 💼 MIT
          ==> 🧭 https://rubygems.org/gems/rails
          ==> 🏠 https://rubyonrails.org
          ==> 🔗 https://github.com/rails/rails/tree/v6.1.3.2
          #{"==> 📑 https://github.com/rails/rails/releases/tag/v6.1.3.2".light_cyan}
          #{"==> 💌 https://discuss.rubyonrails.org/c/rubyonrails-talk".light_cyan}
        OUTPUT
      end

      it 'outputs the gem details' do
        expect(display).to eq output
      end
    end

    context 'with a missing source_code_uri' do
      let(:json) do
        serializer_json(:rails)[:gems].first.tap {|rails| rails.delete :source_code_uri }
      end

      let(:output) do
        <<~OUTPUT.chomp
          #{"=> 💎 rails is at 6.1.3.2".green}
          ==> 📅 May 5, 2021
          ==> 💼 MIT
          ==> 🧭 https://rubygems.org/gems/rails
          ==> 🏠 https://rubyonrails.org
          #{"==> 🔗 Unavailable".light_red}
          #{"==> 📑 https://github.com/rails/rails/releases/tag/v6.1.3.2".light_cyan}
          #{"==> 💌 https://discuss.rubyonrails.org/c/rubyonrails-talk".light_cyan}
        OUTPUT
      end

      it 'outputs the gem details with 🔗 Unavailable (in light red)' do
        expect(display).to eq output
      end
    end

    context 'with an empty source_code_uri' do
      let(:json) do
        serializer_json(:rails)[:gems].first.tap {|rails| rails[:source_code_uri] = '' }
      end

      let(:output) do
        <<~OUTPUT.chomp
          #{"=> 💎 rails is at 6.1.3.2".green}
          ==> 📅 May 5, 2021
          ==> 💼 MIT
          ==> 🧭 https://rubygems.org/gems/rails
          ==> 🏠 https://rubyonrails.org
          #{"==> 🔗 Unavailable".light_red}
          #{"==> 📑 https://github.com/rails/rails/releases/tag/v6.1.3.2".light_cyan}
          #{"==> 💌 https://discuss.rubyonrails.org/c/rubyonrails-talk".light_cyan}
        OUTPUT
      end

      it 'outputs the gem details with 🔗 Unavailable (in light red)' do
        expect(display).to eq output
      end
    end

    context 'with a missing changelog_uri' do
      let(:json) do
        serializer_json(:rails)[:gems].first.tap {|rails| rails.delete :changelog_uri }
      end

      let(:output) do
        <<~OUTPUT.chomp
          #{"=> 💎 rails is at 6.1.3.2".green}
          ==> 📅 May 5, 2021
          ==> 💼 MIT
          ==> 🧭 https://rubygems.org/gems/rails
          ==> 🏠 https://rubyonrails.org
          ==> 🔗 https://github.com/rails/rails/tree/v6.1.3.2
          #{"==> 📑 Unavailable".light_red}
          #{"==> 💌 https://discuss.rubyonrails.org/c/rubyonrails-talk".light_cyan}
        OUTPUT
      end

      it 'outputs the gem details with 📑 Unavailable (in light red)' do
        expect(display).to eq output
      end
    end

    context 'with an empty changelog_uri' do
      let(:json) do
        serializer_json(:rails)[:gems].first.tap {|rails| rails[:changelog_uri] = '' }
      end

      let(:output) do
        <<~OUTPUT.chomp
          #{"=> 💎 rails is at 6.1.3.2".green}
          ==> 📅 May 5, 2021
          ==> 💼 MIT
          ==> 🧭 https://rubygems.org/gems/rails
          ==> 🏠 https://rubyonrails.org
          ==> 🔗 https://github.com/rails/rails/tree/v6.1.3.2
          #{"==> 📑 Unavailable".light_red}
          #{"==> 💌 https://discuss.rubyonrails.org/c/rubyonrails-talk".light_cyan}
        OUTPUT
      end

      it 'outputs the gem details with 📑 Unavailable (in light red)' do
        expect(display).to eq output
      end
    end

    context 'with a missing mailing_list_uri' do
      let(:json) do
        serializer_json(:rails)[:gems].first.tap {|rails| rails.delete :mailing_list_uri }
      end

      let(:output) do
        <<~OUTPUT.chomp
          #{"=> 💎 rails is at 6.1.3.2".green}
          ==> 📅 May 5, 2021
          ==> 💼 MIT
          ==> 🧭 https://rubygems.org/gems/rails
          ==> 🏠 https://rubyonrails.org
          ==> 🔗 https://github.com/rails/rails/tree/v6.1.3.2
          #{"==> 📑 https://github.com/rails/rails/releases/tag/v6.1.3.2".light_cyan}
          #{"==> 💌 Unavailable".light_red}
        OUTPUT
      end

      it 'outputs the gem details with 💌 Unavailable (in light red)' do
        expect(display).to eq output
      end
    end

    context 'with an empty mailing_list_uri' do
      let(:json) do
        serializer_json(:rails)[:gems].first.tap {|rails| rails[:mailing_list_uri] = '' }
      end

      let(:output) do
        <<~OUTPUT.chomp
          #{"=> 💎 rails is at 6.1.3.2".green}
          ==> 📅 May 5, 2021
          ==> 💼 MIT
          ==> 🧭 https://rubygems.org/gems/rails
          ==> 🏠 https://rubyonrails.org
          ==> 🔗 https://github.com/rails/rails/tree/v6.1.3.2
          #{"==> 📑 https://github.com/rails/rails/releases/tag/v6.1.3.2".light_cyan}
          #{"==> 💌 Unavailable".light_red}
        OUTPUT
      end

      it 'outputs the gem details with 💌 Unavailable (in light red)' do
        expect(display).to eq output
      end
    end

    context 'when the gem lookup timed out' do
      let(:json) do
        serializer_json(:not_found)[:gems].first.tap {|g| g[:timeout] = true }
      end

      let(:output) { '=> 💎 not_found lookup timed out'.red }

      it 'outputs the gem lookup timed out (red)' do
        expect(display).to eq output
      end
    end

    context 'when the gem does not exist' do
      let(:json)   { serializer_json(:not_found)[:gems].first }
      let(:output) { '=> 💎 not_found not found'.red }

      it 'outputs the gem is not found (red)' do
        expect(display).to eq output
      end
    end
  end

  describe '.gem_count' do
    subject(:gem_count) do
      capture_output { described_class.gem_count num: num }.chomp
    end

    let(:num)    { junk :int, min: 1, max: 1_000 }
    let(:output) { "=> 🤔 #{num} gems".light_cyan }

    it 'outputs a thinking emoji with the number of gems (light cyan)' do
      expect(gem_count).to eq output
    end
  end

  describe '.batch_iterator' do
    subject(:batch_iterator) do
      capture_output { described_class.batch_iterator num: num, total: total }.chomp
    end

    let(:num)    { junk :int, min: 1, max: 499 }
    let(:total)  { junk :int, min: 500, max: 1_000 }
    let(:output) { "=> 🧺 #{num} of #{total}".yellow }

    it 'outputs a basket emoji with the current number of total batches (yellow)' do
      expect(batch_iterator).to eq output
    end
  end

  describe '.querying' do
    subject(:querying) do
      capture_output { described_class.querying batch: batch }.chomp
    end

    let(:batch)  { [junk, junk, junk, junk] }
    let(:output) { "=> 🔎 #{batch.join(", ")}".light_yellow }

    it 'outputs a magnifying glass emoji with the gems in the current batch (light yellow)' do
      expect(querying).to eq output
    end
  end

  describe '.streaming?' do
    it 'returns true' do
      expect(described_class).to be_streaming
    end
  end
end
# rubocop:enable Metrics/BlockLength
