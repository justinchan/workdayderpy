class ScrapeController < ApplicationController
	def index
		hash_table = Hash.new
		Picture.all.each do |pic|
			hash_table[pic.url] = 1
		end
		require 'net/http'
		require 'json'
		url = URI.parse('https://api.groupme.com/groups/4600386/messages?token=ab32b920b6940130a343663e2468da7d')
		resp_unparsed = Net::HTTP.get_response(url)
		resp = JSON.parse resp_unparsed.body

		resp = resp["response"]
		count = resp["count"]
		messages = resp["messages"]

		#Begin new shit
		

		not_done_yet = true
		running_count = 0
		message_id = 0
		messages.each do |message|
			running_count +=1
			message_id = message["id"]
			picture_url = message["picture_url"]
			if picture_url
				if !hash_table.has_key?(picture_url)
					pic = Picture.new
					pic.url = picture_url
					pic.actual_picture = pic.picture_from_url(picture_url)
					pic.save
				end
			end
		end
		while(not_done_yet)
			url = URI.parse("https://api.groupme.com/groups/4600386/messages?token=ab32b920b6940130a343663e2468da7d&before_id=#{message_id}")
			resp_unparsed = Net::HTTP.get_response(url)
			resp = JSON.parse resp_unparsed.body
			resp = resp["response"]
			messages = resp["messages"]


			messages.each do |message|
				running_count += 1
				message_id = message["id"]
				picture_url = message["picture_url"]
				if picture_url
					if !hash_table.has_key?(picture_url)
						pic = Picture.new
						pic.url = picture_url
						pic.actual_picture = pic.picture_from_url(picture_url)
						pic.save
					end
				end
			end
			if running_count == count
				not_done_yet = false
			end
		end
	end
end
