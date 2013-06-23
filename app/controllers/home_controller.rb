class HomeController < ApplicationController
	def index
		require 'net/http'
		require 'json'
		text = params[:text].downcase

		if params[:name] != 'Lady Gaga'
			if text["poker"] != nil
				url = URI.parse('https://api.groupme.com/v3/bots/post')
				post_args = {"bot_id" => '87bd4bf2d3fad44c47c534ab36', "text" => "P-p-p-p-pokerface"}.to_json
				a = ActiveSupport::JSON.decode(post_args)
				resp, data = Net::HTTP.post_form(url, a)
			elsif text == 'kanye weather'
				url = URI.parse('https://api.forecast.io/forecast/e9ae28050324270567556f2425a62c3f/37.6933,-121.9241?exclude=[minutely,hourly,daily,alerts,flags]')
				resp_unparsed = Net::HTTP.get_response(url)
				resp = JSON.parse resp_unparsed.body
				current_weather = resp["currently"]
				temp = current_weather["temperature"]
				if temp < 60
					message = "it's colder than the reception I got after the VMAs!"
				elsif temp >= 60 and temp < 75
					message = "the weather is fine, just like me. Kanye is so fine."
				else
					message = "DAMNN IT'S HOT OUTSIDE!"
				end
				summary = current_weather["summary"]
				summary.downcase!
				post_args = {"bot_id" => '87bd4bf2d3fad44c47c534ab36', "text" => "#{temp} degrees outside -- #{summary}. In Kanye's words, #{message}"}.to_json
				url = URI.parse('https://api.groupme.com/v3/bots/post')
				a = ActiveSupport::JSON.decode(post_args)
				resp, data = Net::HTTP.post_form(url, a)
			elsif text == 'kanye stats'
				url = URI.parse('https://api.groupme.com/groups/4767983/messages?token=ab32b920b6940130a343663e2468da7d')
				resp_unparsed = Net::HTTP.get_response(url)
				resp = JSON.parse resp_unparsed.body
				resp = resp[:response]
				count = resp[:count]
				messages = resp[:messages]
				temp_counter = 0
				messages.each do |message|
					temp_counter = temp_counter + 1
				end


				url = URI.parse('https://api.groupme.com/v3/bots/post')
				post_args = {"bot_id" => '87bd4bf2d3fad44c47c534ab36', "text" => "#{count} total messages. I counted #{temp_counter}."}.to_json
				a = ActiveSupport::JSON.decode(post_args)
				resp, data = Net::HTTP.post_form(url, a)
			end
		end
	end
end
