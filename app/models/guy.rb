# Guy model - represents IRC user (called "guy").
#
# *Properties*
# - +nickname+ - String - unique key to identity guy
# - +created_at+ - DateTime - creating time
# - +messages_count+ - Integer - count of guy writed messages
#
# *Relations*
# - has n, +messages+
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
