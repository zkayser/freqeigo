class Subcategory
  include Mongoid::Document
  field :subcategory, type: String
  belongs_to :category
  belongs_to :deck
  accepts_nested_attributes_for :category
end
