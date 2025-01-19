require 'open3'
require_relative 'config'

Misspelling = Data.define(:word, :suggestions)

module Heckler
  class Aspell
    @process = nil

    def initialize(config)
      @config = config
    end

    def check(text)
      misspellings = get_misspellings(text)
      misspellings.reject { |misspelling| @config.word_ignored?(misspelling.word) }
    end

    private

    def get_misspellings(text)
      run(text)
    end

    def take_suggestions(suggestions)
      suggestions = suggestions.select { |suggestion| suggestion.match(/[^a-zA-Z]/).nil? }
      suggestions.uniq
    end

    def run(text)
      stdin, stdout, stderr, _wait_thr = Open3.popen3('aspell', '--encoding', 'utf-8', '-a', '--ignore-case',
                                                      '--lang=en_US', '--sug-mode=ultra')
      stdin.puts text
      stdin.close
      output = stdout.read
      stdout.close
      stderr.close

      output.lines.select { |line| line.start_with?('&') }.map do |line|
        word_metadata, suggestions = line.strip.split(':')
        word = word_metadata.split(' ')[1]
        suggestions = suggestions.strip.split(', ')
        Misspelling.new(word, take_suggestions(suggestions))
      end
    end
  end
end
