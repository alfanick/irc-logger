class Channel
  include DataMapper::Resource
  
  property :id, Serial

  property :name, String, :nullable => false, :format => /^#\w+/
  property :created_at, DateTime
  property :status, Enum[:enabled, :inactive, :disabled], :default => :disabled
  
  belongs_to :server
end
