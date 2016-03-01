#!/usr/bin/env ruby
require 'telegram/bot'
require 'json'

def boobs(bot, message)
  get = 'http://api.oboobs.ru/noise/1'
  res = getRekt(get)

  data = JSON.parse(res.body)
  img = data[0]['preview']

  st = getRekt('http://media.oboobs.ru/' + img)
  img.slice! 'noise_preview/'

  File.write(img, st.body)
  bot.api.send_photo(chat_id: message.chat.id, photo: File.new(img))
  File.delete(img)
end

def butts(bot, message)
  get = 'http://api.obutts.ru/noise/1'
  res = getRekt(get)

  data = JSON.parse(res.body)
  img = data[0]['preview']

  st = getRekt('http://media.obutts.ru/' + img)
  img.slice! 'noise_preview/'

  File.write(img, st.body)
  bot.api.send_photo(chat_id: message.chat.id, photo: File.new(img))
  File.delete(img)
end

def bewbz(bot, message)
  boobs(bot, message)
end
