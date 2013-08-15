class FotosController < ApplicationController
	def index
		require 'net/http'
		require 'json'
		url = URI.parse('https://api.groupme.com/groups/4600386/messages?token=ab32b920b6940130a343663e2468da7d')
		resp_unparsed = Net::HTTP.get_response(url)
		resp = JSON.parse resp_unparsed.body
		@attachment = resp
		resp = resp["response"]
		count = resp["count"]
		messages = resp["messages"]

		#Begin new shit
		attachments = resp["attachments"]
		if attachments
			attachments.each do |attachment|
				url = URI.parse('https://api.groupme.com/v3/bots/post')
				post_args = {"bot_id" => '87bd4bf2d3fad44c47c534ab36', "text" => "#{attachment["url"]}"}.to_json
				a = ActiveSupport::JSON.decode(post_args)
				resp, data = Net::HTTP.post_form(url, a)
			end
		end


		top_chatter = Hash.new{|h,k| h[k] = 0}
		top_chatter_likes = Hash.new{|h,k| h[k] = 0}
		not_done_yet = true
		running_count = 0
		message_id = 0
		messages.each do |message|
			running_count +=1
			user = message["name"]
			likes = message["favorited_by"].length
			top_chatter[user] +=1
			top_chatter_likes[user] += likes
			message_id = message["id"]
		end
		while(not_done_yet)
			url = URI.parse("https://api.groupme.com/groups/4600386/messages?token=ab32b920b6940130a343663e2468da7d&before_id=#{message_id}")
			resp_unparsed = Net::HTTP.get_response(url)
			resp = JSON.parse resp_unparsed.body
			resp = resp["response"]
			messages = resp["messages"]
			attachments = resp["attachments"]
			if attachments
				attachments.each do |attachment|
					if attachment["type"] == "image"
						url = URI.parse('https://api.groupme.com/v3/bots/post')
						post_args = {"bot_id" => '87bd4bf2d3fad44c47c534ab36', "text" => "#{attachment["url"]}"}.to_json
						a = ActiveSupport::JSON.decode(post_args)
						resp, data = Net::HTTP.post_form(url, a)
					end
				end
			end
			messages.each do |message|
				running_count += 1
				user = message["name"]
				likes = message["favorited_by"].length
				top_chatter[user] +=1
				top_chatter_likes[user] += likes
				message_id = message["id"]
			end
			if running_count == count
				not_done_yet = false
			end
		end
		winner_string = ""
		top_chatter_ratio = Hash.new{|h,k| h[k] = 0}
		for i in 1..20
			winner_pair = top_chatter.max_by{|k,v| v}
			winner_name = winner_pair[0]
			winner_value = winner_pair[1]
			winner_string << "#{i}) #{winner_name}, #{winner_value}. " 
			top_chatter[winner_name] = 0
		end
		url = URI.parse('https://api.groupme.com/v3/bots/post')
		post_args = {"bot_id" => '87bd4bf2d3fad44c47c534ab36', "text" => "#{winner_string}"}.to_json
		a = ActiveSupport::JSON.decode(post_args)
		resp, data = Net::HTTP.post_form(url, a)
	end
end
