module Heckler
  class Preset
    PRESET_STUBS_DIRECTORY = File.join(__dir__, "/presets")

    def self.whitelisted_words(preset)
      return [] if preset.nil? || !stub_exists?(preset)

      get_words_from_stub("base") + get_words_from_stub(preset)
    end

    def self.get_words_from_stub(preset)
      path = File.join(PRESET_STUBS_DIRECTORY, "#{preset}.stub")
      File.read(path).lines.map(&:strip).reject(&:empty?)
    end

    def self.stub_exists?(preset)
      File.exist?(File.join(PRESET_STUBS_DIRECTORY, "#{preset}.stub"))
    end
  end
end
