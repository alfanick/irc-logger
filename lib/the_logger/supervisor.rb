require 'rubygems'
require 'starling'

# Logging machine
module TheLogger
  # Supervisor (task planner)
  class Supervisor
    # Create supervisor
    #
    # Params:
    # - +server+ - String - Starling server and port
    # - +listeners+ - Array - Listeners names
    def initialize(server, listeners)
      @server = server
      @listeners = listeners
      @last_listener = nil
      @channels = []
      
      @starling = Starling.new(@server)
    end
    
    # Start task planning
    def start
      loop do
        # Go through servers
        Server.all(:status => :enabled).each do |server|
          # Go through channels
          server.channels.all(:status => :enabled).each do |channel|
            # Next channel if current channel is watched
            next if @channels.include? channel
            # Add channel to queue
            @starling.set(next_listener, { :server => server.host, :channel => channel.name })
            # Mark channel as watched
            @channels.push channel
          end
        end
        # Next round
        sleep 300
      end
    end
    
    # Stop listening
    def stop
      # Go through listeners
      @listeners.each do |listener|
        # Add :exit command to queue
        @starling.set(listener, :exit)
      end
    end
    
    private
      def next_listener
        @last_listener = @listeners.at(@listeners.index(@last_listener).to_i + 1) or @listeners.first
      end
  end
end
