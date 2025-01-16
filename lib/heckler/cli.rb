require 'optparse'

require_relative "config"
require_relative "aspell"
require_relative "preset"
require_relative "checker/file_system"


module Heckler
  class Runner
    attr_reader :checkers

    def initialize(checkers)
      @checkers = checkers
    end

    def run(directory)
      issues = []

      puts directory

      @checkers.each do |checker|
        issues.concat(checker.check(directory))
      end

      issues
    end
  end

  class CLI
    def self.start(args)
      command = args.shift

      case command
      when 'init'
        Config.init
      when nil
        config = Config.instance
        aspell = Aspell.new(config)

        Runner.new([
          Heckler::Checker::FileSystem.new(config, aspell)
        ]).run(Dir.pwd)
      else
        puts "Unknown command: #{command}"
        puts "Available commands: init, or no command for default behavior"
      end
    end
  end
end
