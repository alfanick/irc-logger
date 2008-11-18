class Message
  include DataMapper::Resource
  
  property :id, Serial

  property :content, Text, :nullable => false, :lazy => false
  property :created_at, DateTime

  belongs_to :guy
end
