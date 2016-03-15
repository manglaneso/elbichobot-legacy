#!/usr/bin/env ruby
require 'telegram/bot'

token = '210974192:AAGhSHZWwTQ8sdD6CCTS2PaHBC34Udpl_Nw'

# Hash to store command => method
hash = {}

# http Get request
def getRekt(uri)
  url = URI.parse(uri)
  req = Net::HTTP::Get.new(url.to_s)
  res = Net::HTTP.start(url.host, url.port) {|http|
    http.request(req)
  }
  @ret = res
end

# Require all modules and store their methods not belonging to a class in the hash
Dir['../modules/*.rb'].each do |file|
  require file
  f = File.open(file, 'r')
  f.each_line do |line|
    if line.start_with?('def ')
      line.slice! 'def '
      l = line.gsub(/[()]/, '')
      l.slice! ('bot, message')
      command = '/' + l
      hash[command] = l
    end
  end
end

# Main loop
Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    Thread.new {
      begin
        if message.text == 'me he perdido' or message.text == 'Me he perdido'
          bot.api.send_sticker(chat_id: message.chat.id, sticker: 'BQADBAADpwMAAirpFAABvX17hai0B3oC', reply_to_message_id: message.message_id)
        elsif message.text == 'que?' or message.text == 'Que?'
          bot.api.send_message(chat_id: message.chat.id, text: 'Cacahue', reply_to_message_id: message.message_id)
        end
        # If command has one argument
        if message.text.include? " "
          t = message.text.gsub(/\s+/m, ' ').strip.split(" ")
          if hash.has_key?(t[0] + "\n")
            send(hash[t[0] + "\n"].chomp, bot, message)
          end
        else
          # If command has no arguments
          if hash.has_key?(message.text + "\n")
            send(hash[message.text + "\n"].chomp, bot, message)
          end
        end
      rescue Telegram::Bot::Exceptions::ResponseError => e
        puts e.message
      end
    }
  end
end
