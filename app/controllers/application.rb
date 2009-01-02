class Application < Merb::Controller
  def initialize(*args)
    super(*args)
    @title = ""
  end
end