class Message
  include DataMapper::Resource
  
  property :id, Serial

  property :content, Text, :nullable => false, :lazy => false
  property :created_at, DateTime,
    :default => Proc.new { Time.now }

  belongs_to :guy
end
