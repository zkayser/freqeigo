class EmbeddedWord
  include Mongoid::Document
  embedded_in :word_list
  embeds_many :translations, cascade_callbacks: true
  field :word, type: String
  field :hiragana, type: String
  field :reading, type: String
  field :note, type: String
  
  
  accepts_nested_attributes_for :translations, :allow_destroy => true
  

end
