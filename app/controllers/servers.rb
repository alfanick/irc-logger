class Servers < Application
  # provides :xml, :yaml, :js

	cache :index

  def index
    @servers = Server.all
    display @servers
  end
end # Servers
