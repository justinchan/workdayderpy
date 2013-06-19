class HomeController < ApplicationController
	def index
		require 'net/http'
		require 'json'
		url = URI.parse('https://api.groupme.com/v3/bots/post')
		post_args = {"bot_id" => '87bd4bf2d3fad44c47c534ab36', "text" => "Poke whose face?"}.to_json
		a = ActiveSupport::JSON.decode(post_args)
		text = params[:text].downcase
		if params[:name] != 'Lady Gaga'
			if text["poker"] != nil
				resp, data = Net::HTTP.post_form(url, a)
			end
		end
	end
end
