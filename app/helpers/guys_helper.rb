module Merb
  module GuysHelper
    include MessagesHelper
    
    def font_size(guy)
      Merb::Cache[:default].fetch(guy.id.to_s + "_fonts", :interval => Time.now.to_i / Merb::Config[:cache]["intervals"]["font_size"]) do
        (150 * (1 + (1.5*guy.messages_count - 300/2)/300))
      end
    end
  end
end # Merb
