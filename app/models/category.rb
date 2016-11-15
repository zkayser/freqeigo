class Category
  include Mongoid::Document
  field :category, type: String
  belongs_to :user
  belongs_to :deck
  has_many :subcategories
  validates_presence_of :category
end
