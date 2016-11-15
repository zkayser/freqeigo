class Lexicon
  include Mongoid::Document
  field :surface, type: String # => This will be the distinctive form of the input word, received from the constituents of a sentence object.
  field :kanji, type: String   # => 
  field :hiragana, type: String # => Hiragana dictionary form(s) of the given item.
  field :romaji, type: String # => Romaji forms of the given item.
  belongs_to :word
end

