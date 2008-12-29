class Messages < Application
	cache :log, :index, :more

  def index(query, page = 1)
    if params.include? 'query' and not params['query'].empty?
      @messages = Message.weight_search(:conditions => [params['query']], :limit => 10, :offset => 10 * (page.to_i-1))
    else
      @messages = Message.all(:limit => 10, :offset => 10 * (page.to_i-1), :order => [:created_at.desc])
    end
    display @messages
  end

  def show(id)
    @message = Message.get(id)
    raise NotFound unless @message
    display @message
  end

	def more(id, limit)
		@messages = Message.get(id.to_i).related(limit.to_i).to_a
		
		if limit.to_i > 0
			date = @messages.last.created_at.to_s
		else
			date = @messages.first.created_at.to_s
		end
		
		data = { :date => date, :content => @messages.map{ |m| "<li id='message_#{m.id}' class='message'>#{format_message(m)}</li>" }.join }
		
		display data, :layout => false, :format => :json
	end
  
  def log(host, channel, year, month, day)
		only_provides :log
	
    from = Time.local(year.to_i, month.to_i, day.to_i)
    to = from + 1.day
  
    @messages = Server.first(:host=>host).channels.first(:name=>'#' + channel).messages(:created_at => (from..to), :event => :message, :order=>[:created_at.asc])
    
    raise NotFound if @messages.empty?
    
    display @messages
  end
end # Messages
