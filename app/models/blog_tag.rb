class BlogTag
  include Mongoid::Document
  embedded_in :blog
  field :tag, type: String
end
