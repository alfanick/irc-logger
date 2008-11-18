class Guy
  include DataMapper::Resource
  
  property :nickname, String, :key => true, :length => (1..60)
  property :created_at, DateTime

  has n, :messages
end
