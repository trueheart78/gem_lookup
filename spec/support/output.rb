# frozen_string_literal: true

module Support
  module Output
    def capture_output
      new_stdout = StringIO.new
      old_stdout = $stdout
      $stdout = new_stdout
      yield
      $stdout.string
    ensure
      $stdout = old_stdout
    end
    alias suppress_output capture_output
  end
end
