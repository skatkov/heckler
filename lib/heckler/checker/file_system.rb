require_relative "../aspell"

require "find"

# The Checker::FileSystem class provides functionality to check spelling in file and directory names within a given directory structure.
#
# Usage:
#   checker = Checker::FileSystem.new
#   issues = checker.check("/path/to/directory")
#
# The check method:
# - Recursively traverses the given directory
# - Skips hidden files/directories (starting with .)
# - Skips .git directories
# - Checks spelling of each file/directory name
# - Returns an array of Issue objects containing any misspellings found
#
# Each Issue object contains:
# - The misspelling that was found
# - The full path to the file/directory
# - The line number (always 0 for filenames)
module Heckler
  class Checker
    class FileSystem
      def initialize(config, spellchecker)
        @config = config
        @spellchecker = spellchecker
      end

      def check(directory)
        files_or_directories = []
        Find.find(directory) do |path|
          next if File.basename(path).start_with?(".")
          next if File.fnmatch("*/.git/*", path)

          files_or_directories << path
        end


        files_or_directories.sort_by! { |path| File.realpath(path) }

        puts files_or_directories

        issues = []

        files_or_directories.each do |file_or_directory|
          name = SpellcheckFormatter.format(File.basename(file_or_directory, ".*"))
          new_issues = @spellchecker.check(name).map do |misspelling|
            Issue.new(misspelling, File.realpath(file_or_directory), 0)
          end

          issues.concat(new_issues)
        end

        issues
      end
    end
  end

  class SpellcheckFormatter
    def self.format(input)
      # Remove leading underscores
      input = input.gsub(/^_+/, "")

      # Replace underscores and dashes with spaces
      input = input.tr("_-", " ")

      # Insert spaces between lowercase and uppercase letters (camelCase or PascalCase)
      input = input.gsub(/([a-z])([A-Z])/, '\1 \2')

      # Split sequences of uppercase letters, ensuring the last uppercase letter starts a new word
      input = input.gsub(/([A-Z]+)([A-Z][a-z])/, '\1 \2')

      # Replace multiple spaces with a single space
      input = input.gsub(/\s+/, " ")

      # Convert the final result to lowercase
      input.downcase
    end
  end

  class Issue
    attr_reader :misspelling, :file, :line

    def initialize(misspelling, file, line)
      @misspelling = misspelling
      @file = file
      @line = line
    end
  end
end
