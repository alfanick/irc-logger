class Guys < Application
  # provides :xml, :yaml, :js

	cache :index, :show

  def index(page=1)
    @guys = Guy.all(:order => [:nickname.asc], :limit => 200, :offset => 200 * (page.to_i-1))
    raise NotFound if @guys.empty?
    display @guys
  end

  def show(nickname)
    @guy = Guy.get(nickname)
    raise NotFound unless @guy
    display @guy
  end
end # Guys
