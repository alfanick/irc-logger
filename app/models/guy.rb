class Guy
  include DataMapper::Resource
  
  property :nickname, String, :key => true, :length => (1..60)
  property :created_at, DateTime
  property :messages_count, Integer, :default => 0

  has n, :messages
  
  # Return channel list where the Guy was
  def channels
    messages.map { |m| m.channel }.uniq
  end
end
