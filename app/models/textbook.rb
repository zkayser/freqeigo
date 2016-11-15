class Textbook
  include Mongoid::Document
  field :title, type: String
  field :table_of_contents, type: String
  field :course_id, type: String
  embeds_many :lessons
  belongs_to :course
  
  accepts_nested_attributes_for :lessons
end
