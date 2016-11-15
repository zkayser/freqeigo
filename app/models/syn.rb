class Syn
  include Mongoid::Document
  field :synonym, type: String
  has_and_belongs_to_many :words
end
