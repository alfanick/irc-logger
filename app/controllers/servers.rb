# Servers controller. List logged servers.
class Servers < Application
	cache :index

	# List logged servers.
	#
	# *Cached*
  def index
    @servers = Server.all
    display @servers
  end
end # Servers
