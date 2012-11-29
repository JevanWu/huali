# encoding: utf-8
class Forgery::LoremIpsum < Forgery
  protected
    def self.lorem_ipsum_words
      @@lorem_ipsum_words ||= dictionaries[:words].shuffle()
    end

    def self.lorem_ipsum_characters
      @@lorem_ipsum_characters ||= dictionaries[:words].shuffle().join("")
    end
end
