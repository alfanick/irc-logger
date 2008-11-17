class Channels < Application
  # provides :xml, :yaml, :js

  def index
    @channels = Channel.all
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

  def edit(id)
    only_provides :html
    @channel = Channel.get(id)
    raise NotFound unless @channel
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

  def update(id, channel)
    @channel = Channel.get(id)
    raise NotFound unless @channel
    if @channel.update_attributes(channel)
       redirect resource(@channel)
    else
      display @channel, :edit
    end
  end

  def destroy(id)
    @channel = Channel.get(id)
    raise NotFound unless @channel
    if @channel.destroy
      redirect resource(:channels)
    else
      raise InternalServerError
    end
  end

end # Channels
