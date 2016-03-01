#!/usr/bin/env ruby

def dicks(bot, message)
  get = getRekt('http://dicks-api.herokuapp.com/dicks/1')
  data = JSON.parse(get.body)
  bot.api.send_message(chat_id: message.chat.id, text: data['dicks'][0])
end
