class HomeController < ApplicationController
	def index
		require 'net/http'
		require 'json'
		text = params[:text].downcase
		url = URI.parse('https://api.groupme.com/v3/bots/post')
		post_args = {"bot_id" => '87bd4bf2d3fad44c47c534ab36', "text" => "Pokerface"}.to_json
		a = ActiveSupport::JSON.decode(post_args)
		if params[:name] != 'Lady Gaga'
			if text["poker"] != nil
				resp, data = Net::HTTP.post_form(url, a)
			# elsif text == 'kanye weather'
			# 	url = URI.parse('https://api.forecast.io/forecast/e9ae28050324270567556f2425a62c3f/37.6933,-121.9241')
			# 	resp_unparsed = Net::HTTP.get_response(url)
			# 	resp = JSON.parse resp_unparsed.body
			# 	current_weather = resp["currently"]
			# 	temp = current_weather["temperature"]
			# 	summary = current_weather["summary"]
			# 	summary.downcase!
			# 	post_args = {"bot_id" => '87bd4bf2d3fad44c47c534ab36', "text" => "#{temp} degrees outside -- #{summary}."}.to_json
			# 	url = URI.parse('https://api.groupme.com/v3/bots/post')
			# 	a = ActiveSupport::JSON.decode(post_args)
			# 	resp, data = Net::HTTP.post_form(url, a)
			end
		end
	end
end
