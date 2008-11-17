class Messages < Application
  # provides :xml, :yaml, :js

  def index
    @messages = Message.all
    display @messages
  end

  def show(id)
    @message = Message.get(id)
    raise NotFound unless @message
    display @message
  end

  def new
    only_provides :html
    @message = Message.new
    display @message
  end

  def edit(id)
    only_provides :html
    @message = Message.get(id)
    raise NotFound unless @message
    display @message
  end

  def create(message)
    @message = Message.new(message)
    if @message.save
      redirect resource(@message), :message => {:notice => "Message was successfully created"}
    else
      message[:error] = "Message failed to be created"
      render :new
    end
  end

  def update(id, message)
    @message = Message.get(id)
    raise NotFound unless @message
    if @message.update_attributes(message)
       redirect resource(@message)
    else
      display @message, :edit
    end
  end

  def destroy(id)
    @message = Message.get(id)
    raise NotFound unless @message
    if @message.destroy
      redirect resource(:messages)
    else
      raise InternalServerError
    end
  end

end # Messages
