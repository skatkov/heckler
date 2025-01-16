require "json"
require "singleton"
require_relative "preset"

module Heckler
  class Config
    include Singleton

    JSON_CONFIGURATION_NAME = "heckler.json".freeze

    attr_accessor :whitelisted_words, :whitelisted_paths, :preset

    def initialize
      @whitelisted_words = []
      @whitelisted_paths = []
      @preset = nil
      load_config
    end

    def self.flush
      instance.whitelisted_words = []
      instance.whitelisted_paths = []
      instance.preset = nil
      @resolve_config_file_path_using = nil
    end

    def self.exists?
      File.exist?(Dir.pwd + "/" + JSON_CONFIGURATION_NAME)
    end

    def self.init
      file_path = Dir.pwd + "/" + JSON_CONFIGURATION_NAME

      return false if File.exist?(file_path)

      configuration = {
        preset: "base",
        ignore: {
          words: [],
          paths: ["tmp/", "log/"]
        }
      }

      File.write(file_path, JSON.pretty_generate(configuration))
      true
    end

    def ignore_words(words)
      @whitelisted_words.concat(words.map(&:downcase)).uniq!
      persist
    end

    def word_ignored?(word)
      @whitelisted_words.include?(word.downcase) ||
        Preset.whitelisted_words(@preset).include?(word.downcase)
    end

    private

    def load_config
      base_path = Dir.pwd
      file_path = base_path + "/" + (self.class.instance_variable_get(:@resolve_config_file_path_using)&.call || JSON_CONFIGURATION_NAME)

      contents = File.exist?(file_path) ? File.read(file_path) : "{}"
      json_as_array = JSON.parse(contents, symbolize_names: true) rescue {}

      @whitelisted_words = (json_as_array.dig(:ignore, :words) || []).map(&:downcase)
      @whitelisted_paths = json_as_array.dig(:ignore, :paths) || []
      @preset = json_as_array[:preset]
    end

    def persist
      file_path = Dir.pwd + "/" + JSON_CONFIGURATION_NAME

      configuration = {
        preset: @preset,
        ignore: {
          words: @whitelisted_words,
          paths: @whitelisted_paths
        }
      }.compact

      File.write(file_path, JSON.pretty_generate(configuration))
    end
  end
end
