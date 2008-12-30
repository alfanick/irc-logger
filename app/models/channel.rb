# Channel model - represents IRC channel.
#
# *Properties*
# - +id+ - Serial - unique identificator
# - +name+ - String - channel name
# - +created_at+ - DateTime - creating time
# - +status+ - Symbol - channel status (:enabled, :inactive, :disabled)
# - +messages_count+ - Integer - channel messages count
#
# *Relations*
# - belongs_to +server+
# - has n, +messages+
class Channel
  include DataMapper::Resource
  
  property :id, Serial

  property :name, String, :nullable => false, :format => /^#\w+/
  property :created_at, DateTime
  property :status, Enum[:enabled, :inactive, :disabled], :default => :inactive
  property :messages_count, Integer, :default => 0
  
  belongs_to :server
  has n, :messages
end
