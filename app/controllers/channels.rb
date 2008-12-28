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

  def create(channel)
    @channel = Channel.new(channel)
    if @channel.save
      redirect resource(@channel), :message => {:notice => "Channel was successfully created"}
    else
      message[:error] = "Channel failed to be created"
      render :new
    end
  end
end # Channels
