class Servers < Application
  # provides :xml, :yaml, :js

  def index
    @servers = Server.all
    display @servers
  end

  def show(id)
    @server = Server.get(id)
    raise NotFound unless @server
    display @server
  end

  def new
    only_provides :html
    @server = Server.new
    display @server
  end

  def edit(id)
    only_provides :html
    @server = Server.get(id)
    raise NotFound unless @server
    display @server
  end

  def create(server)
    @server = Server.new(server)
    if @server.save
      redirect resource(@server), :message => {:notice => "Server was successfully created"}
    else
      message[:error] = "Server failed to be created"
      render :new
    end
  end

  def update(id, server)
    @server = Server.get(id)
    raise NotFound unless @server
    if @server.update_attributes(server)
       redirect resource(@server)
    else
      display @server, :edit
    end
  end

  def destroy(id)
    @server = Server.get(id)
    raise NotFound unless @server
    if @server.destroy
      redirect resource(:servers)
    else
      raise InternalServerError
    end
  end

end # Servers
