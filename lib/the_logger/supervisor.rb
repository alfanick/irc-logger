require 'rubygems'
require 'starling'

# Logging machine
module TheLogger
	PING_QUEUE = '__ping'
	
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
						representation = { :server => server.host, :channel => channel.name }
            # Next channel if current channel is watched
            next if @channels.include? representation
            # Add channel to queue
            @starling.set(next_listener, representation)
            # Mark channel as watched
            @channels.push representation
          end
        end
				
				# Make ping request
				@listeners.each do |listener|
					@starling.set(listener, :ping)
				end
				
				# Clear channels list
				@channels.clear
				
				# Wait for listeners
				sleep 5
				
				# Get logged channels
				@starling.flush(PING_QUEUE) do |channels|
					@channels += channels
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
    
    # Clean queues
    def clean
      # Go through listener
      @listeners.each do |listener|
        # Flush queue
        @starling.flush(listener) {}
      end
    end
    
    private
      def next_listener
        @last_listener = @listeners.at(@listeners.index(@last_listener).to_i + 1) or @listeners.first
      end
  end
end
