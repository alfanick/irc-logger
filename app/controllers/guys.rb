# Guys controller. Display guys statitics and 
# guys listing.
class Guys < Application
	cache :index, :show

	# Display guys cloud.
	#
	# *Cached*
	#
	# *Raise* - NotFound
	#
	# *Attributes*
	# - +page+ - Integer - page number
  def index(page=1)
    @guys = Guy.all(:order => [:nickname.asc], :limit => 200, :offset => 200 * (page.to_i-1))
    raise NotFound if @guys.empty?
    display @guys
  end

	# Display guy statistics, latest messages.
	#
	# *Cached*
	#
	# *Raise* - NotFound
	#
	# *Attributes*
	# - +nickname+ - String - guy nickname
  def show(nickname)
    @guy = Guy.get(nickname)
    raise NotFound unless @guy
    display @guy
  end
end # Guys
