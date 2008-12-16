class Messages < Application
  provides :xml, :yaml, :js

  def index(page = 1)
    if params.include? 'query' and not params['query'].empty?
      @messages = Message.weight_search(:conditions => [params['query']], :limit => 10, :offset => 10 * (page.to_i-1))
    else
      @messages = Message.all(:limit => 10, :offset => 10 * (page.to_i-1), :order => [:created_at.desc])
    end
    display @messages
  end

  def show(id)
    @message = Message.get(id)
    raise NotFound unless @message
    display @message
  end
end # Messages
