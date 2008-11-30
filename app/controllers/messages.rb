class Messages < Application
  provides :xml, :yaml, :js

  def index
    if params.include? 'query' and not params['query'].empty?
      @messages = Message.search(:conditions => ['-event 3|4|5', params['query']], :limit => 10).reverse
    else
      @messages = Message.all(:limit => 20).reverse
    end
    display @messages
  end

  def show(id)
    @message = Message.get(id)
    raise NotFound unless @message
    display @message
  end
end # Messages
