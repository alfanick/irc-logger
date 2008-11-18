class Server
  include DataMapper::Resource
  
  property :host, String, :key => true
  property :name, String, :default => Proc.new { |s,p| s.host }
  property :port, Integer, :default => 6667
  property :status, Enum[:enabled, :inactive, :disabled], :default => :inactive

  has n, :channels
end
