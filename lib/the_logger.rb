require 'net/yail/IRCBot'

class TheLogger < IRCBot
  attr_accessor :server

  def initialize(server)
    @server = server
  
    options = {
      :irc_network => server.host,
      :port => server.port,
      :username => "thelogger_#{Process.pid}",
      :realname => 'IRC logging bot',
      :nicknames => ["thelogger_#{Process.pid}"],
      :silent => true
    }
    
    super(options)
    
    self.connect_socket
    self.start_listening
    
    server.channels.each do |ch|
      join ch.name
    end
    
    self.irc_loop
  end
  
  def add_custom_handlers
    @irc.prepend_handler(:incoming_msg,             self.method(:_in_msg))
#    @irc.prepend_handler(:incoming_act,             self.method(:_in_act))
#    @irc.prepend_handler(:incoming_invite,          self.method(:_in_invited))
#    @irc.prepend_handler(:incoming_kick,            self.method(:_in_kick))

#    @irc.prepend_handler(:outgoing_join,            self.method(:_out_join))
  end

  def self.fork_loggers
    loggers = []
    
    Server.all(:status => :enabled).each { |sv| loggers << TheLogger.new(sv) }
    
    return loggers
  end
  
  private
    def _in_msg(fullactor, user, channel, text)
      return if channel =~ /^#{bot_name}/
      
      guy = Guy.first(:nickname => user) || Guy.new(:nickname => user)
      guy.save
      
      ch = @server.channels.first(:name => channel)
      
      msg = Message.new(:content => text, :channel => ch, :guy => guy)
      msg.save
    end
end
