class Message
  include DataMapper::Resource
  
  property :id, Serial

  property :content, Text, :nullable => false, :lazy => false
  property :event, Enum[:message, :join, :mode, :part, :kick], :default => :message
  property :created_at, DateTime

  belongs_to :guy
  belongs_to :channel
  
  is :searchable
  
  def related(n)
    if n > 0
      channel.messages.all(:limit => n, :created_at.gt => created_at)
    else
      channel.messages.all(:limit => n.abs, :order => [:created_at.desc], :created_at.lt => created_at).reverse
    end
  end
  
  def with_surroundings(n=5)
    related(-n) + [self] + related(n)
  end
end
