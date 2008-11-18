class Guy
  include DataMapper::Resource
  
  property :id, Serial
  
  property :nickname, String, :nullable => false, :length => (1..60)
  property :created_at, DateTime

  has n, :messages
end
