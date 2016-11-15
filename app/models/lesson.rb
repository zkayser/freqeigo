class Lesson
  include Mongoid::Document
  field :title, type: String
  embedded_in :textbook
  embeds_many :objectives
  
  accepts_nested_attributes_for :objectives
end
