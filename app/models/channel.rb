class Channel
  include DataMapper::Resource
  
  property :id, Serial

  property :name, String, :nullable => false
  property :created_at, DateTime,
    :default => Proc.new { Time.now }
  
  belongs_to :server
end
