class Objective
  include Mongoid::Document
  field :name, type: String
  field :content, type: String
  embedded_in :lesson
end
