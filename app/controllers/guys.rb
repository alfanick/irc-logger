class Guys < Application
  # provides :xml, :yaml, :js

  def index
    @guys = Guy.all
    display @guys
  end

  def show(nickname)
    @guy = Guy.get(nickname)
    raise NotFound unless @guy
    display @guy
  end
end # Guys
