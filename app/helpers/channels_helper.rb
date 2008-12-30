module Merb
  # Channels helpers.
	module ChannelsHelper
		include MessagesHelper

		# Compute font-size for channels cloud.
		#
		# *Cached*
		#
		# *Parameters*
		# - +channel+ - Channel - channel
		#
		# *Return* - String - CSS part
		def font_size(channel)
      Merb::Cache[:default].fetch(channel.id.to_s + "_ch_fonts", :interval => Time.now.to_i / Merb::Config[:cache]["intervals"]["font_size"]) do
        mx = Channel.max(:messages_count)

				x = (150 * (1 + (1.5*channel.messages_count.to_i - mx/2)/mx))
        
        x = 400 if x > 400
        
        "font-size: %i%%;" % x
      end
    end
  end
end # Merb