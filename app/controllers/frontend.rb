class Frontend < Application
  cache :index, :about

  def index
    render
  end
  
  def about
    render
  end
  
end
