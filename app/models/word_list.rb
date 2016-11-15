class WordList
  include Mongoid::Document
  include Deckifiable
  
  field :title, type: String
  belongs_to :course
  has_and_belongs_to_many :words
  embeds_many :embedded_words, cascade_callbacks: true
  
  validates_presence_of :title
  accepts_nested_attributes_for :embedded_words, :reject_if => lambda { |a| a[:word].blank? }, :allow_destroy => true
  
end
