#!/usr/bin/env ruby
require 'telegram/bot'

def echo(bot, message)
  if message.text.include? " "
    message.text.slice! '/echo '
    bot.api.send_message(chat_id: message.chat.id, text: message.text)
  end
end
