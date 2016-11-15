class Word
  include Mongoid::Document
  include Sunspot::Mongo
  include CardAttributes
  include Cardifiable
  include Japanese::Conjugator
  include Japanese::VerbIdentifier
  paginates_per 10
  has_and_belongs_to_many :word_lists
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :example_sentences
  has_and_belongs_to_many :syns
  has_and_belongs_to_many :ants
  has_many :lexicon_items, class_name: "Lexicon"
  embeds_many :translations
  field :word, type: String # To make this work, this is going to have to represent the base form of a word.
  field :hiragana, type: String
  field :reading, type: String
  # field :senses, type: String #=> Tentatively thinking about adding this as an attribute. 
  field :note, type: String
  field :part_of_speech, type: String
  field :conjugations, type: Hash, default: {}
  # field :synonyms, type: String # => Needs to be changed since these were extracted out to their own models
  # field :antonyms, type: String # => This one too.
  field :priority, type: String
  field :word_list_id, type: String
  field :has_imperative, type: Boolean
  field :has_passive, type: Boolean
  field :has_volitional, type: Boolean
  field :has_causative, type: Boolean
  field :passive_forms, type: Hash, default: {}
  field :passive_forms_hiragana, type: Hash, default: {}
  field :passive_forms_romaji, type: Hash, default: {}
  field :causative_forms, type: Hash, default: {}
  field :causative_forms_hiragana, type: Hash, default: {}
  field :causative_forms_romaji, type: Hash, default: {}
  field :has_causative_passive, type: Boolean
  field :causative_passive_forms, type: Hash, default: {}
  field :causative_passive_forms_hiragana, type: Hash, default: {}
  field :causative_passive_forms_romaji, type: Hash, default: {}
  field :stem_form, type: String
  field :hiragana_forms, type: Hash, default: {}
  field :romaji_forms, type: Hash, default: {}
  field :negative_stem, type: String
  field :base, type: String
  field :passive_dictionary_form, type: String
  field :causative_dictionary_form, type: String
  field :causative_passive_dictionary_form, type: String
  set_default_card_pairings [:word, :hiragana], [:word, :reading], [:word, :translations], [:hiragana, :word], [:translations, :word]
  
  # different parts of speech to identify words. However, an original validation that checks
  # that there are not any words with both the same WORD and PART_OF_SPEECH should be used instead.w
  validates :part_of_speech, presence: true, on: :create, allow_nil: false
  accepts_nested_attributes_for :translations, :tags, :syns, :ants
  
  searchable do
    text :word, :hiragana, :reading
    text :translation do
      translations.map { |t| t.translation }
    end
  end
  
  # Notes on parts of speech: Refer to https://en.wikipedia.org/wiki/Japanese_verb_conjugation
  # Notable: adj-t are たる adjective; v5k-s is 行く/ゆく; v5r-i is ある; v5u-s is for verbs like 問う that have odd endings
  PARTS_OF_SPEECH = %w(noun adj-i adi-na adj-t adv-to aux aux-v aux-adj verb v1 v5b v5g v5k v5k-s v5m v5n 
                       v5r v5r-i v5s v5t v5u v5u-s v-aru v-kuru v-suru copula particle compound-particle noun-na-adjective
                       noun-suru-verb saying grammatical-construct counter conjunction)
  
  before_create :process_verb
  before_validation :convert_hiragana, :set_verb_behavior_types
  before_validation :resolve_verb_class, if: ->{ self.part_of_speech == 'verb' }
  
  def set_verb_behavior_types
    if part_of_speech == "verb" || part_of_speech.in?(%w(v1 v5b v5g v5k v5k-s v5m v5n v5r v5r-i v5s v5t v5u v5u-s v-aru v-kuru v-suru))
      attrs = %w(imperative passive volitional causative causative_passive)
      attrs.each do |a|
        unless self.send("has_#{a}") == false
          eval "self.has_#{a} = true"
        end
      end
    end
  end
  
  # Converts the hiragana to romaji
  def convert_hiragana
    dup = self.hiragana.dup
    self.reading = Japanese::HiraganaConverter.convert_hiragana(dup)
  end
  
  # This method probably belongs in the Card class or Cardify module rather than
  # here.
  def to_card(deck)
    self.cardify(deck)
  end
    
  def extract_verb_forms
    word_forms = [self.word, self.stem_form, self.passive_dictionary_form, self.causative_dictionary_form, self.causative_passive_dictionary_form, 
                  conjugations[:te_form], conjugations[:ta_form], conjugations[:prohibitive], conjugations[:plain_present_potential], 
                  conjugations[:conditional]]
      polites = self.conjugations[:polite_forms].values
      polites.each do |p|
        word_forms << p
      end
      negs = self.conjugations[:negative_plain_forms].values
      negs.each do |n|
        word_forms << n
      end
      cons = self.conjugations[:continuous_forms].values
      cons.each do |con|
        word_forms << con
      end
      pass_polites = self.passive_forms[:polite_forms].values
      pass_polites.each do |polite|
        word_forms << polite
      end
      pass_negs = self.passive_forms[:negative_plain_forms].values
      pass_negs.each do |neg|
        word_forms << neg
      end
      pass_cons = self.passive_forms[:continuous_forms].values
      pass_cons.each do |con|
        word_forms << con
      end
      caus_polites = self.causative_forms[:polite_forms].values
      caus_polites.each do |polite|
        word_forms << polite
      end
      caus_negs = self.causative_forms[:negative_plain_forms].values
      caus_negs.each do |neg|
        word_forms << neg
      end
      caus_cons = self.causative_forms[:continuous_forms].values
      caus_cons.each do |con|
        word_forms << con
      end
      caus_pass_polites = self.causative_passive_forms[:polite_forms].values
      caus_pass_polites.each do |polite|
        word_forms << polite
      end
      caus_pass_negs = self.causative_passive_forms[:negative_plain_forms].values
      caus_pass_negs.each do |neg|
        word_forms << neg
      end
      caus_pass_cons = self.causative_passive_forms[:continuous_forms].values
      caus_pass_cons.each do |con|
        word_forms << con
      end
      te_ta_forms = [self.passive_forms[:te_form], self.passive_forms[:ta_form], self.causative_forms[:te_form], self.causative_forms[:ta_form], 
                     self.causative_passive_forms[:te_form], self.causative_passive_forms[:ta_form]]
      conditional_forms = [self.causative_forms[:conditional], self.passive_forms[:conditional], self.causative_passive_forms[:conditional]]
      misc_forms = [self.causative_forms[:imperative], self.causative_forms[:volitional], self.causative_forms[:prohibitive]]
      te_ta_forms.each do |form|
        word_forms << form
      end
      conditional_forms.each do |form|
        word_forms << form
      end
      misc_forms.each do |form|
        word_forms << form
      end
      word_forms.compact!
    return word_forms.uniq
  end
  
  # This method can be made more efficient by looking into the sunspot documentation
  # and figuring out how you can constrain the search on ExampleSentence to be done 
  # only on ExampleSentences that are not already included in the word objects example_sentences association.
  # Also note that this really only works with verbs as it stands right now.
  # WHAT TO DO ABOUT WORDS THAT TAKE THE SAME FORM?
  def search_example_sentences_for_word
    word_forms = self.extract_verb_forms
    search_hits = [] # Put example sentence object hits in this array
    word_forms.each do |wf|
      search = ExampleSentence.solr_search do
        fulltext wf
      end
      if search.results.any?
        search_hits << search.results
        search_hits.uniq # Filter out any duplicate hits
        exs = self.example_sentences.to_a
        potential_exs = exs + search_hits # Create an array of the hits combined with the existing example sentences
        potential_exs.delete_if do |example|
          exs.include?(example) # Discard the matched example if it already exists in the self.example_sentences array
        end
        correct_matches = self.remove_errant_matches_from(potential_exs) # Prevent surface matches only from being added to the Word's example sentences
        self.example_sentences << correct_matches # Add on the new, unique example sentences found.
        return potential_exs
      else
        puts "No matches found"
      end
    end
  end
  
  # Doing a simple solr_search will turn out anything that matches on the surface, regardless of whether or not
  # the result being searched for actually matches the word_object
  def remove_errant_matches_from(pot_ex_array)
    correct_match_arr = []
    pot_ex_array.each do |example|
      constituents = example.construct_constituents_array
      constituents.each do |const_array|
        if const_array[0] == self.word && const_array[1] == self.hiragana && const_array[3] == self.reading # For this to work, the constituents have to be normalized to dictionary_forms.
          correct_match_arr << example
        end
      end
    end
    return correct_match_arr
  end
        
  # TODO: Create a hook so that, when a new word is created and example sentences are added to it,
  # the example sentence updates its html_sentence string to factor in the new link available.
  
  # Conjugation processing logic is contained in lib/japanese_conjugator.rb module
  
  # Creates new lexicon items using all forms of a given verb.
  def add_forms_to_lexicon
    word = self
    forms = self.extract_verb_forms
    forms.each do |form|
      Lexicon.create!(item: form, kanji: word.word, hiragana: word.hiragana, romaji: word.reading, word: word)
    end
  end
end
