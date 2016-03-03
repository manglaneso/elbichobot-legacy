#!/usr/bin/env ruby

def bicho(bot, message)
  bot.api.send_audio(chat_id: message.chat.id, audio: File.new('../audio/bicho.ogg'))
end

def siuu(bot, message)
  bot.api.send_audio(chat_id: message.chat.id, audio: File.new('../audio/siuuu.ogg'))
end

def jaj(bot, message)
  bot.api.send_audio(chat_id: message.chat.id, audio: File.new('../audio/jaj.ogg'))
end
