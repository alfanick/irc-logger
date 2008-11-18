class Server
  include DataMapper::Resource
  
  property :id, Serial
  
  property :host, String, :nullable => false
  property :port, Integer, :default => Proc.new { 6667 }

  has n, :channels
end
