class Channels < Application
  # provides :xml, :yaml, :js

  def index(page = 1)
    @channels = Channel.all(:limit => 50, :offset => 50 * (page.to_i-1))
		raise NotFound if @channels.empty?
    display @channels
  end

  def show(id)
    @channel = Channel.get(id)
    raise NotFound unless @channel
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
