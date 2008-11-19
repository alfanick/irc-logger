require 'net/yail/IRCBot'

# Logging bot
class TheLogger < IRCBot
  # Attached server model
  attr_accessor :server

  # Initialize the logger. Start listening
  #
  # *Arguments*:
  # - +server+ - Server - server model
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
  
  # Prepare events for listening
  def add_custom_handlers
    @irc.prepend_handler :incoming_msg,             self.method(:_in_msg)
    @irc.prepend_handler :incoming_kick,            self.method(:_in_kick)
    @irc.prepend_handler :incoming_mode,            self.method(:r_mode)
    @irc.prepend_handler :incoming_join,            self.method(:r_join)
    @irc.prepend_handler :incoming_part,            self.method(:r_part)
  end

  # Start listen. Each server has own thread.
  #
  # *Return* - Array - Threads
  def self.fork_loggers
    logging_threads = []
    
    Server.all(:status => :enabled).each do |sv|
      logging_threads << Thread.new(sv) do |s|
        TheLogger.new(s) 
      end
    end
    
    logging_threads.each { |lt|  lt.join }
    
    return logging_threads
  end
  
  private
    def add_notice(channel, user, text)
      return if channel =~ /^#{bot_name}/
      
      guy = Guy.first_or_create(:nickname => user)
      guy.save
    
      ch = @server.channels.first_or_create(:name => channel, :status => :enabled)
      ch.save!
      
      msg = Message.new(:content => "*** #{text}", :channel => ch, :guy => guy, :notice => true)
      msg.save
    end
  
    def _in_msg(fullactor, user, channel, text)
      return if channel =~ /^#{bot_name}/
      
      guy = Guy.first_or_create(:nickname => user)
      guy.save
      
      ch = @server.channels.first(:name => channel, :status => :enabled)
      
      msg = Message.new(:content => text, :channel => ch, :guy => guy)
      msg.save
    end
    
    def _in_kick(fullactor, actor, target, object, text)
      if object == bot_name
        join(target) 
      else
        add_notice(target, actor, "#{actor} kicked #{object} (#{text})")
      end

      return true
    end
    
    def r_mode(fullactor, actor, target, modes, objects)
      add_notice(target, actor, "#{actor} sets mode #{modes} #{objects}")
    end

    def r_join(fullactor, actor, target)
      add_notice(target, actor, "#{actor} joins")
    end

    def r_part(fullactor, actor, target, text)
      add_notice(target, actor, "#{actor} parts (#{text})")
    end 
end
