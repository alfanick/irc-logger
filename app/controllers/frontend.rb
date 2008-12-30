# Frontend controller. Serve statics pages.
class Frontend < Application
  cache :index, :about

	# Render index - show channels and messages
	# statistics.
	#
	# *Cached*
  def index
    render
  end
  
	# Render about page - informations about irc-logger.
	#
	# *Cached*
  def about
    render
  end
  
end
