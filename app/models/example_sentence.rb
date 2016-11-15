class ExampleSentence
  include Mongoid::Document
  include Sunspot::Mongo
  include CardAttributes
  include Cardifiable
  include Japanese::Parser
  has_and_belongs_to_many :words
  embeds_many :example_translations
  field :sentence, type: String
  field :romaji, type: String
  field :hiragana, type: String
  field :language, type: String
  field :surface_constituents, type: Array
  field :reading_constituents, type: Array
  field :romaji_constituents, type: Array
  field :pos_constituents, type: Array
  field :baseform_constituents, type: Array
  field :lex_items_hash, type: Hash, default: {}
  field :as_words, type: String # => Process the sentence, break into individual words, put them into the array.
  
  set_default_card_pairings [:sentence, :example_translations], [:example_translations, :sentence]
  
  validates :sentence, presence: true
  
  # Enables grouping of Japanese character and grammatical marks into constituents if white space is placed in between.
  JAPANESE_CHUNK_REGEX = /([\p{Han}|\p{Katakana}|\p{Hiragana}|\p{Hangul}|【,】,。,.,！,!,、,”,",＜,＞,<,>,（,）,(,),¥,※,「,」,ー,〜,~,？,?]+)/
  JAPANESE_PUNCTUATION = %w(【 】 ！ 、（ ） ¥ 「 」 ” ＜ ＞ 。 ？, .)
  # Mongoid has the method #search, so with sunspot you need to use the 
  # method #solr_search. Check out the documentation at https://github.com/derekharmel/sunspot_mongo.
  
  searchable do
    text :sentence, stored: true
    text :translation do
      example_translations.map { |et| et.example_translation }
    end
  end
  
  accepts_nested_attributes_for :example_translations
  Mongoid.raise_not_found_error = false
  before_validation :set_constituents, on: :create
  after_validation :initialize_as_words, on: :create
  
  # FIXME -> Move the punctuation handling to the hiragana converter. 
  # You can have it normalize the conversion to English punctuation.
  def initialize_as_words
    self.as_words = ""
    romaji_constituents.each_with_index do |const, i|
      unless const.in?(JAPANESE_PUNCTUATION)
        if romaji_constituents[i + 1].in?(JAPANESE_PUNCTUATION)
          self.as_words += const
        else
          self.as_words += const += " "
        end
      else
        if const == "、"
          self.as_words += ", "
        end
      end
    end
  end
  
  # Groups together constituents by kanji (or main form), hiragana, and romaji for use in construct_constituents_array.
  def group_matching_constituents(index)
    matching_array = []
    matching_array << self.constituents[index]
    matching_array << self.hiragana_constituents[index]
    matching_array << self.romaji_constituents[index]
    return matching_array
  end
end