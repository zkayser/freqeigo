json.array!(@blogs) do |blog|
  json.extract! blog, :id, :title, :posted, :author, :content, :picture
  json.url blog_url(blog, format: :json)
end
