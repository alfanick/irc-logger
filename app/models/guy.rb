class Guy
  include DataMapper::Resource
  
  property :id, Serial
  
  property :nickname, String, :nullable => false
  property :created_at, DateTime,
    :default => Proc.new { Time.now }

  has n, :messages
end
