require 'digest/sha1'

class Message
  include DataMapper::SphinxResource
  
  property :id, Serial

  property :content, Text, :nullable => false, :lazy => false
  property :event, Enum[:message, :join, :mode, :part, :kick], :default => :message
  property :created_at, DateTime

  belongs_to :guy
  belongs_to :channel
  
  # Make search query to Sphinx
  # Thank you shanna
  def self.weight_search(search_options = {}, options = {})
    Merb::Cache[:default].fetch(Digest::SHA1.hexdigest(search_options.inspect) + "_search", :interval => Time.now.to_i / Merb::Config[:cache]["intervals"]["weight_search"]) do
      docs = repository(:search){self.all(search_options)}
      ids = docs.map{|doc| doc[:id]}
      results = self.all(options.merge(:id => ids))
     
      # Sort by the ids which are ordered by :weight in the first place.
      results.sort{|a, b| ids.index(a.id) <=> ids.index(b.id)}
    end
  end 
  
  # Calculate guys distribution within message
  def self.guys_distribution(quality = 10)
    max_messages = Guy.max(:messages_count)
    results = Hash.new
    step = max_messages/quality
    
    quality.times do |i|
      range = (i*step)...((i+1)*step)
      results[range] = Guy.count(:messages_count => range)
    end
    
    results.sort { |a, b| a[0].first <=> b[0].first }
  end
  
  def related(n, events=true)
    Merb::Cache[:default].fetch("#{self.id}_#{n}_#{events}_related", :interval => Time.now.to_i / Merb::Config[:cache]["intervals"]["related"]) do
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
  
  before :create do
    if event == :message
      guy.messages_count += 1
      guy.save!
      
      channel.messages_count += 1
      channel.save!
    end
  end
  
  before :destroy do
    if event == :message
      guy.messages_count -= 1
      guy.save!
      
      channel.messages_count -= 1
      channel.save!
    end
  end
end
