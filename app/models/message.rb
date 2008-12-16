require 'digest/sha1'

class Message
  include DataMapper::SphinxResource
  
  property :id, Serial

  property :content, Text, :nullable => false, :lazy => false
  property :event, Enum[:message, :join, :mode, :part, :kick], :default => :message
  property :created_at, DateTime

  belongs_to :guy
  belongs_to :channel
  
  # Thank you shanna
  def self.weight_search(search_options = {}, options = {})
    Merb::Cache[:default].fetch(Digest::SHA1.hexdigest(search_options.inspect) + "_search", :interval => Time.now.to_i / 300) do
      docs = repository(:search){self.all(search_options)}
      ids = docs.map{|doc| doc[:id]}
      results = self.all(options.merge(:id => ids))
     
      # Sort by the ids which are ordered by :weight in the first place.
      results.sort{|a, b| ids.index(a.id) <=> ids.index(b.id)}
    end
  end 
  
  def related(n, events=true)
    Merb::Cache[:default].fetch("#{self.id}_#{n}_#{events}_related", :interval => Time.now.to_i / 300) do
      if events
        e = [:message, :join, :mode, :part, :kick]
      else
        e = :message
      end
    
      if n > 0
        channel.messages.all(:limit => n, :created_at.gt => created_at, :order => [:created_at.asc], :event => e)
      else
        channel.messages.all(:limit => n.abs, :order => [:created_at.desc], :created_at.lt => created_at, :event => e).reverse!
      end
    end
  end
  
  def with_surroundings(n=5, events=true)
    if n.class == Range
      related(n.first, events) + [self] + related(n.last, events)
    else
      related(-n, events) + [self] + related(n, events)
    end
  end
end
