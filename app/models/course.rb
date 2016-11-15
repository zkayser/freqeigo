class Course
  include Mongoid::Document
  field :title, type: String
  field :summary, type: String
  field :level, type: String
  field :appx_length, type: String
  has_and_belongs_to_many :users
  has_one :word_list
  has_one :deck
  has_one :textbook
  
  scope :beginner, ->{ where(level: "Beginner") }
  scope :medium, ->{ where(level: "Medium") }
  scope :advanced, ->{ where(level: "Advanced") }
end
