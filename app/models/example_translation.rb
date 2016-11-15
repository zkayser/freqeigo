class ExampleTranslation
  include Mongoid::Document
  embedded_in :example_sentence
  field :example_translation, type: String
end
