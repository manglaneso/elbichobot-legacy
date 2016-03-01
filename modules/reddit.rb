#!/usr/bin/env ruby
require 'open-uri'
require 'ruby_reddit_api'
require 'telegram/bot'
require 'json'
require 'net/http'

class Redditier

  def initialize(subreddit, destination)
    @subreddit = subreddit
    @path = destination
    @downloaded = []
    @not_downloaded = []
  end

  def path
    @path
  end

  def jif
    @jif
  end

  def download
    begin
      # make me a reddit client please
      r = Reddit::Api.new

      options = {:limit => 100}
      # update image
      posts = r.browse(@subreddit, options)
      posts.shuffle.each do |r|
        @not_downloaded << r.url if r.url.include?('imgur') or r.url.include?('gfycat') or r.url.include?('vine.co') or r.url.include?('streamable') or r.url.include?('youtube') or r.url.include?('tumblr') or r.url.include?('twitter') or r.url.include?('vid.me') or r.url.include?('xvideos') or r.url.include?('xhamster') or r.url.include?('pornhub') and !@downloaded.include?(r.url)
      end

      image = @not_downloaded.shift

      #@jif = image
      #@ret = 2

#=begin
      if image.include?('imgur')

        if image.include?('gif') or image.include?('a.') or image.include?('m.') or image.include?('.webm') or image.include?('://imgur')
          @jif = image
          @ret = 2
        elsif !image.include?('.jpg') or !image.include?('.png') or !image.include?('.jpeg') or !image.include?('.tif') or !image.include?('.bmp')
          imaging = open(image).read
          if image.include?('https://')
            image.slice! 'https://i.imgur.com/'
          elsif image.include?('http://')
            image.slice! 'http://i.imgur.com/'
          else

          end

          #@path = @path + image
          @path = image
          File.write  @path, imaging
          @ret = 1
        end

      # Uncomment the the following block if you are on a fast connection to send gifs as documents
=begin
      elsif image.include?('gfycat')


        imaging = open(image).read
        image.slice! 'http://gfycat.com/'
        i = 'http://gfycat.com/cajax/get/' + image

        url = URI.parse(i)
        req = Net::HTTP::Get.new(url.to_s)
        res = Net::HTTP.start(url.host, url.port) {|http|
          http.request(req)
        }

        data = JSON.parse(res.body)
        gifurl = data['gfyItem']['gifUrl']
        @jif = gifurl
        if !gifurl.include?('zippy')
        @ret = 1
        end
        imaging1 = open(gifurl).read


        if gifurl.include?('zippy')
          gifurl.slice! 'https://zippy.gfycat.com/'
        elsif gifurl.include?('fat')
          gifurl.slice! 'https://fat.gfycat.com/'
        elsif gifurl.include?('giant')
          gifurl.slice! 'https://giant.gfycat.com/'
        else
          @ret = 0
        end

        @path = @path + gifurl
        File.write  @path, imaging1
=end
      else
        @jif = image
        @ret = 2
      end
#=end
    rescue
      @ret = 0
    end
  end
end

def r(bot, message)
  if message.text != nil and message.text.start_with?('/r ')
    j = message.text
    j.slice! "/r "
    downloader = Redditier.new j, File.basename(Dir.getwd)

    d = downloader.download
    if d != 0
      if d == 1
        begin
          bot.api.send_photo(chat_id: message.chat.id, photo: File.new(downloader.path))
          File.delete(downloader.path)
        rescue Exception => e
          puts e.message
        end
      else
        bot.api.send_message(chat_id: message.chat.id, text: downloader.jif)
        #bot.api.send_document(chat_id: message.chat.id, document: File.new(downloader.path))
      end
    else
      bot.api.send_message(chat_id: message.chat.id, text: 'Sorry but there is not a subreddit /r/' + j)
    end
  end
end
