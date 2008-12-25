class Servers < Application
  # provides :xml, :yaml, :js

  def index
    @servers = Server.all
    display @servers
  end
end # Servers
