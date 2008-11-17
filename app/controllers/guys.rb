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

  def new
    only_provides :html
    @guy = Guy.new
    display @guy
  end

  def edit(id)
    only_provides :html
    @guy = Guy.get(id)
    raise NotFound unless @guy
    display @guy
  end

  def create(guy)
    @guy = Guy.new(guy)
    if @guy.save
      redirect resource(@guy), :message => {:notice => "Guy was successfully created"}
    else
      message[:error] = "Guy failed to be created"
      render :new
    end
  end

  def update(id, guy)
    @guy = Guy.get(id)
    raise NotFound unless @guy
    if @guy.update_attributes(guy)
       redirect resource(@guy)
    else
      display @guy, :edit
    end
  end

  def destroy(id)
    @guy = Guy.get(id)
    raise NotFound unless @guy
    if @guy.destroy
      redirect resource(:guys)
    else
      raise InternalServerError
    end
  end

end # Guys
