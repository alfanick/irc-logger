require 'rubygems'
require 'net/yail/IRCBot'

# Logging machine
module TheLogger
  # Logging bot
  class Bot < IRCBot
    # Attached server model
    attr_accessor :server

    # Initialize the logger. Start listening
    #
    # *Arguments*:
    # - +server+ - String
    # - +name+ - String
    def initialize(server, name)
      @server = Server.first(:host => server)
      @active_channels = { }
      @active_guys = { }
    
      options = {
        :irc_network => @server.host,
        :port => @server.port,
        :username => "the_logger_#{name}",
        :realname => 'IRC logging bot',
        :nicknames => ["the_logger_#{name}"],
        :silent => true
      }
      
      super(options)
      
      self.connect_socket
      self.start_listening
    end
    
    # Prepare events for listening
    def add_custom_handlers
      @irc.prepend_handler :incoming_msg, self.method(:_in_msg)
      @irc.prepend_handler :incoming_kick, self.method(:_in_kick)
      @irc.prepend_handler :incoming_mode, self.method(:r_mode)
      @irc.prepend_handler :incoming_join, self.method(:r_join)
      @irc.prepend_handler :incoming_part, self.method(:r_part)
    end
    
    # Join channel
    def join channel
      self.irc.join channel
      
      fetch_channel channel
    end
    
    # Fetch channel object
    def fetch_channel name
      @active_channels[name] or (@active_channels[name] = @server.channels.first(:name => name, :status=>:enabled))
    end
    
    # Fetch guy object
    def fetch_guy name
      if not @active_guys.include? name
        @active_guys[name] = Guy.first_or_create(:nickname => name)
      end
      
      @active_guys[name]
    end
    
    private
      # Repairs the channel name (remove hashes)
      #
      # *Arguments*:
      # - +channel+ - String - channel name
      #
      # *Return* - String
      def repair_channel(channel)
        channel.gsub /^#+/, '#'
      end
    
      # Add message to database
      #
      # *Arguments*
      # - +channel+ - String - channel name
      # - +user+ - String - nickname
      # - +text+ - String - text
      # - +event+ - Symbol - message type (:message, :kick, :mode, :join, :part)
      #
      # *Return* - Boolean - success?
      def add_notice(channel, user, text, event)
        return if (channel =~ /^#{bot_name}/ or user == bot_name)
        channel = repair_channel(channel)
        
        begin
          guy = fetch_guy(user)
          return unless guy
        
          ch = fetch_channel(channel)
          return unless ch
        
          msg = Message.new(:content => text, :channel => ch, :guy => guy, :event => event)
          msg.save
        rescue Exception
          Merb.logger.error($!)
        end
      end
    
      # Log channel message
      def _in_msg(fullactor, user, channel, text)
        add_notice(channel, user, text, :message)
      end
      
      # Log kick event (and rejoin if bot is kicked)
      def _in_kick(fullactor, actor, target, object, text)
        if object == bot_name
          join(target) 
        else
          add_notice(target, actor, "#{actor} kicked #{object} (#{text})", :kick)
        end

        return true
      end
      
      # Log mode event
      def r_mode(fullactor, actor, target, modes, objects)
        add_notice(target, actor, "#{actor} sets mode #{modes} #{objects}", :mode)
      end

      # Log join event
      def r_join(fullactor, actor, target)
        add_notice(target, actor, "#{actor} joins", :join)
      end

      # Log part event
      def r_part(fullactor, actor, target, text)
        add_notice(target, actor, "#{actor} parts (#{text})", :part)
      end
  end
end
