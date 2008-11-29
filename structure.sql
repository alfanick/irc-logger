CREATE VIEW "Messages" AS
    SELECT messages.id, 
      guys.nickname, 
      servers.host, 
      servers.name AS server_name, 
      channels.name AS channel_name, 
      messages.event, 
      messages.content 
    FROM (((messages JOIN guys ON (((messages.guy_nickname)::text = (guys.nickname)::text))) JOIN channels ON ((messages.channel_id = channels.id))) JOIN servers ON (((channels.server_host)::text = (servers.host)::text)));
