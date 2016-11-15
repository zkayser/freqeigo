class Comment
  include Mongoid::Document
  field :content, type: String
  field :author, type: String
  field :posted, type: Time
  embedded_in :blog
end
