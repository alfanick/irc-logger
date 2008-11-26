module Merb
  module MessagesHelper
    def format_message (message)
      if message.event == :message
        '<code class="irc message">' + h("<#{message.guy.nickname}> #{message.content}") + '</code>'
      else
        '<code class="irc notice">' + h("*** #{message.content}") + '</code>'
      end
    end
  
    def talk_with (message, n=5)
      str = '<ol class="irc talk">'
      message.with_surroundings(n).each do |msg|
        c = msg.class.name
        cid = c + "_#{msg.id}"
        if msg == message
          str << "<li class=\"result #{c}\" id=\"#{cid}\"><strong>" << format_message(msg) << '</strong></li>'
        else
          str << "<li class=\"#{c}\" id=\"#{cid}\">" << format_message(msg) << "</li>"
        end
      end
      str << '</ol>'
      
      str
    end
  end
end # Merb
