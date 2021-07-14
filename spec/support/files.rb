# frozen_string_literal: true

require 'json'

module Support
  module Files
    def fixture_dir
      File.join Dir.getwd, 'spec', 'fixtures'
    end

    def fixture_path(file)
      File.join fixture_dir, file
    end

    def request_content
      path = request_path

      File.open(path, 'rb', &:read)
    end

    def request_json
      JSON.parse request_content, symbolize_names: true
    end

    def serializer_content(file)
      path = serializer_path file

      File.open(path, 'rb', &:read)
    end

    def serializer_json(file)
      JSON.parse serializer_content(file), symbolize_names: true
    end

    private

    def request_file
      'rails.json'
    end

    def request_path
      File.join(fixture_dir, 'requests', request_file).tap do |path|
        raise "File does not exist [#{path}]" unless File.exist? path
        raise "File is not readable [#{path}]" unless File.readable? path
      end
    end

    def serializer_path(file)
      file = file.to_s
      file = "#{file}.json" unless File.extname(file) == '.json'
      File.join(fixture_dir, 'serializers', file).tap do |path|
        raise "File does not exist [#{path}]" unless File.exist? path
        raise "File is not readable [#{path}]" unless File.readable? path
      end
    end
  end
end
