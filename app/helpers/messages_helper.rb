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
      str = '<div class="irc talk">'
      str << "<h2>#{message.channel.name}</h2> <em class=\"server\">#{message.channel.server.name}</em> "
      ms = message.with_surroundings(n)
      str << "<em class=\"date\">#{ms.first.created_at}</em>"
      str << '<ol>'
      ms.each do |msg|
        c = msg.class.name
        cid = c + "_#{msg.id}"
        if msg == message
          str << "<li class=\"result #{c}\" id=\"#{cid}\"><strong>" << format_message(msg) << '</strong></li>'
        else
          str << "<li class=\"#{c}\" id=\"#{cid}\">" << format_message(msg) << "</li>"
        end
      end
      str << '</ol>'
      str << "<em class=\"date\">#{ms.last.created_at}</em>"
      str << '</div>'
      
      str
    end
  end
end # Merb
