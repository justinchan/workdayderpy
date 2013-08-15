class FotosController < ApplicationController
	def index
		require 'net/http'
		require 'json'
		url = URI.parse('https://api.groupme.com/groups/4600386/messages?token=ab32b920b6940130a343663e2468da7d')
		resp_unparsed = Net::HTTP.get_response(url)
		resp = JSON.parse resp_unparsed.body
		@pictures = []
		resp = resp["response"]
		count = resp["count"]
		messages = resp["messages"]

		#Begin new shit
		if resp["picture_url"]
			@pictures << resp["picture_url"]
		end

		not_done_yet = true
		running_count = 0
		message_id = 0
		messages.each do |message|
			running_count +=1
			message_id = message["id"]
		end
		while(not_done_yet)
			url = URI.parse("https://api.groupme.com/groups/4600386/messages?token=ab32b920b6940130a343663e2468da7d&before_id=#{message_id}")
			resp_unparsed = Net::HTTP.get_response(url)
			resp = JSON.parse resp_unparsed.body
			resp = resp["response"]
			messages = resp["messages"]

			if resp["picture_url"]
				@pictures << resp["picture_url"]
			end

			messages.each do |message|
				running_count += 1
				message_id = message["id"]
			end
			if running_count == count
				not_done_yet = false
			end
		end
	end
end
