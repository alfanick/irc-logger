# Messages controller. The most important controller.
# Display messages, search them, return logs and serve
# AJAX data.
class Messages < Application
	cache :log, :index, :more, :show

	# Search messages. Results are the best matches
	# with context (IRC talk).
	#
	# *Cached*
	#
	# *Parameters*
	# - +query+ - String - search query (see Sphinx extended syntax)
	# - +page+ - Integer - page number
  def index(query, page = 1)
    if params.include? 'query' and not params['query'].empty?
      @messages = Message.weight_search(:conditions => [params['query']], :limit => 10, :offset => 10 * (page.to_i-1))
    else
      @messages = Message.all(:limit => 10, :offset => 10 * (page.to_i-1), :order => [:created_at.desc])
    end
    display @messages
  end

	# Display message with context. It's AJAXable.
	#
	# *Cached*
	#
	# *Raise* - NotFound
	#
	# *Parameters*
	# - +id+ - Integer - message id
	# - +bcount+ - Integer - count of messages before result
	# - +count+ - Integer - count of messages after result
  def show(id, bcount, count)
    @message = Message.get(id)
    raise NotFound unless @message
    display @message
  end

	# Handle AJAX more request.
	#
	# *Cached*
	#
	# *Format* - +:json+
	#
	# *Parameters*
	# - +id+ - Integer - message id
	# - +limit+ - Integer - messages limit (could be less than zero)
	def more(id, limit = 5)
	  only_provides :json
	
		@messages = Message.get(id.to_i).related(limit.to_i).to_a
		
		if limit.to_i > 0
			date = @messages.last.created_at.to_s
		else
			date = @messages.first.created_at.to_s
		end
		
		data = { :date => date, :content => @messages.map{ |m| "<li id='message_#{m.id}' class='message'>#{format_message(m)}</li>" }.join }
		
		render data.to_json, :format => :json
	end
  
	# Generate classic text IRC log.
	#
	# *Cached*
	#
	# *Raise* - NotFound
	#
	# *Format* - +:log+
	#
	# *Parameters*
	# - +host+ - String - server hostname
	# - +channel+ - String - channel name
	# - +year+ - Integer - year
	# - +month+ - Integer - month
	# - +day+ - Integer - day
  def log(host, channel, year, month, day)
		only_provides :log
	
    from = Time.local(year.to_i, month.to_i, day.to_i)
    to = from + 1.day
  
    @messages = Server.first(:host=>host).channels.first(:name=>'#' + channel).messages(:created_at => (from..to), :event => :message, :order=>[:created_at.asc])
    
    raise NotFound if @messages.empty?
    
    display @messages
  end
end # Messages
