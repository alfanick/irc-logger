class Message
  include DataMapper::Resource
  
  property :id, Serial

  property :content, Text, :nullable => false, :lazy => false
  property :event, Enum[:message, :join, :mode, :part, :kick], :default => :message
  property :created_at, DateTime

  belongs_to :guy
  belongs_to :channel
  
  is :searchable
  
  def related(n, events=true)
    if events
      if n > 0
        channel.messages.all(:limit => n, :created_at.gt => created_at)
      else
        channel.messages.all(:limit => n.abs, :order => [:created_at.desc], :created_at.lt => created_at).reverse
      end
    else
      if n > 0
        channel.messages.all(:limit => n, :created_at.gt => created_at, :event => :message)
      else
        channel.messages.all(:limit => n.abs, :order => [:created_at.desc], :created_at.lt => created_at, :event => :message).reverse
      end
    end
  end
  
  def with_surroundings(n=5, events=true)
    related(-n, events) + [self] + related(n, events)
  end
end
