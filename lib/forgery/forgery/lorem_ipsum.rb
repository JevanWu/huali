# encoding: utf-8
class Forgery::LoremIpsum < Forgery

  def self.sentences(quantity=2, options={})
    options.merge!(:random_limit => (dictionaries[:lorem_ipsum].length-quantity)) if quantity.is_a?(Fixnum)

    dictionaries[:lorem_ipsum].shuffle()[range_from_quantity(quantity, options)].join(" ")
  end

  protected
    def self.lorem_ipsum_words
      @@lorem_ipsum_words = dictionaries[:words].shuffle()
    end

    def self.lorem_ipsum_characters
      @@lorem_ipsum_characters = dictionaries[:words].shuffle().join("")
    end
end
