class Guys < Application
  # provides :xml, :yaml, :js

  def index
    @guys = Guy.all
    display @guys
  end

  def show(id)
    @guy = Guy.get(id)
    raise NotFound unless @guy
    display @guy
  end
end # Guys
