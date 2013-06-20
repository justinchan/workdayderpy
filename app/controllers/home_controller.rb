class HomeController < ApplicationController
	def index
		require 'net/http'
		require 'json'
		text = params[:text].downcase

		if params[:name] != 'Lady Gaga'
			if text["hot tub"] != nil
				if text.split(" ").include?('hot')
					temp_bool = false
					if text.split(" ").include?('tub')
						temp_bool = true
					end
					text.split(" ").each do |temp_text| 
						if temp_text.match(/tub\W*\z/) != nil
							temp_bool = true
						end
					end 
					if temp_bool
						url = URI.parse('https://api.groupme.com/v3/bots/post')
						post_args = {"bot_id" => '87bd4bf2d3fad44c47c534ab36', "text" => "Did someone say HOT TUB?!"}.to_json
						a = ActiveSupport::JSON.decode(post_args)
						resp, data = Net::HTTP.post_form(url, a)
					end
				end
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
			elsif text["thanks kanye"] != nil
				first_name_temp = params[:name]
				first_name = first_name_temp.split(" ").first
				url = URI.parse('https://api.groupme.com/v3/bots/post')
				post_args = {"bot_id" => '87bd4bf2d3fad44c47c534ab36', "text" => "Kanye always got your back, #{first_name}."}.to_json
				a = ActiveSupport::JSON.decode(post_args)
				resp, data = Net::HTTP.post_form(url, a)
			end
		end
	end
end
