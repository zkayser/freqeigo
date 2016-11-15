class Ant
  include Mongoid::Document
  field :antonym, type: String
  has_and_belongs_to_many :words
end
