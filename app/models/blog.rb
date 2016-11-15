class Blog
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps
  field :title, type: String
  field :posted, type: Time
  field :author, type: String
  field :content, type: String
  embeds_many :comments
  embeds_many :blog_tags
  
  has_mongoid_attached_file :picture
  
  validates_attachment_content_type :picture, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
end
