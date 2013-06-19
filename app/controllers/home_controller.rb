class HomeController < ApplicationController
	def index
		require 'net/http'
		require 'json'
		url = URI.parse('https://api.groupme.com/v3/bots/post')
		post_args = {"bot_id" => '3b6f5a75557f6eead5ece9a0de', "text" => "Poke whose face?"}.to_json
		a = ActiveSupport::JSON.decode(post_args)
		text = params[:text].downcase
		if params[:name] != 'Lady Gaga'
			if text["poker"] != nil
				resp, data = Net::HTTP.post_form(url, a)
			end
		end
	end
end
