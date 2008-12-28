class Channels < Application
  # provides :xml, :yaml, :js

  def index(server, page = 1)
    @channels = Channel.all(:server_host => server, :limit => 50, :offset => 50 * (page.to_i-1))
		raise NotFound if @channels.empty?
    display @channels
  end

  def show(server, name)
    @channel = Channel.first(:server_host => server, :name => '#' + name)

    raise NotFound unless @channel
		
		@first_date = Channel.messages.first.created_at
		@last_date = Channel.messages.last.created_at
		
    display @channel
  end

  def new
    only_provides :html
    @channel = Channel.new
    display @channel
  end

  def create
		server = Server.first_or_create(:host => params['server'].split(':')[0], :port => (params['server'].split(':')[1] or 6667), :status => :enabled)
		
		data = { :name => params['name'], :server => server }
	
    @channel = Channel.new(data)

    if @channel.save
      redirect url(:frontend), :message => {:notice => "Channel was successfully created"}
    else
      message[:error] = "Channel failed to be created"
      render :new
    end
  end
end # Channels
