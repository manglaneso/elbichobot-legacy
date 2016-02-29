#!/usr/bin/env ruby
require 'telegram/bot'

token = '183010403:AAHc9yYo19nNWwnDVFtluDN3u6hztekidF0'

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
    begin
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
  end
end
