module Merb
	# Guys cloud
  module GuysHelper
    include MessagesHelper
    
		# Compute font-size for guys cloud.
		#
		# *Cached*
		#
		# *Parameters*
		# - +guy+ - Guy - guy
		#
		# *Return* - String - CSS part
    def font_size(guy)
      Merb::Cache[:default].fetch(guy.id.to_s + "_fonts", :interval => Time.now.to_i / Merb::Config[:cache]["intervals"]["font_size"]) do
        mx = Guy.max(:messages_count)
				x = (150 * (1 + (1.5*guy.messages_count.to_i - mx/2)/mx))
        
        x = 400 if x > 400
        
        "font-size: %i%%;" % x
      end
    end
  end
end # Merb
