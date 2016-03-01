#!/usr/bin/env ruby
require 'json'

def danbooru(bot, message)
  base = 'http://danbooru.donmai.us/'
  get = base + 'posts.json?limit=100'
  res = getRekt(get)

  data = JSON.parse(res.body)
  a = Random.rand(100)

  while data[a]['file_ext'] != 'jpg' and data[a]['file_ext'] != 'jpeg' and data[a]['file_ext'] != 'png' and data[a]['file_ext'] != 'tif' and data[a]['file_ext'] != 'bmp'
    a = Random.rand(100)
    res = getRekt(get)
    data = JSON.parse(res.body)
  end

  imgurl = base + data[a]['file_url']
  st = getRekt(imgurl)
  file = data[a]['id'].to_s + '.' + data[a]['file_ext']

  File.write(file, st.body)
  bot.api.send_photo(chat_id: message.chat.id, photo: File.new(file))
  File.delete(file)
end
