class Translation
  include Mongoid::Document
  include Sunspot::Mongo
  embedded_in :word
  field :translation, type: String
  field :language, type: String
  field :hiragana, type: String
  field :reading, type: String
  
  before_save :filter_hiragana
  
  LANGUAGES = ['Japanese', 'English']
  
  searchable do
    text :translation
  end
  
  protected
  
  def filter_hiragana
    unless self.language == "Japanese"
      self.hiragana = ""
    end
  end
end
