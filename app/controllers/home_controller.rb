class HomeController < ApplicationController
	def index
		require 'net/http'
		require 'json'
		require 'rexml/document'
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
				system "rake tabulate &"
				url = URI.parse('https://api.groupme.com/v3/bots/post')
				post_args = {"bot_id" => '87bd4bf2d3fad44c47c534ab36', "text" => "Tabulating results..."}.to_json
				a = ActiveSupport::JSON.decode(post_args)
				resp, data = Net::HTTP.post_form(url, a)
			elsif text.split(" ").length >= 3 and text.split(" ").first == "kanye" and text.split(" ")[1] == "review" and params[:name] == "Justin Chan"
				total_len = text.split(" ").length
				movie_title = params[:text].split(" ")[2, total_len]
				real_movie_title = ""
				changed_title = ""
				movie_title_len_mod = movie_title.length-1
				for i in 0..movie_title_len_mod
					if i == movie_title_len_mod
						changed_title << movie_title[i]
						real_movie_title << movie_title[i]
					else
						changed_title << "#{movie_title[i]}&"
						real_movie_title << "#{movie_title[i]} "
					end
				end
				url = URI.parse("http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=vzfnz8223sf79wn5x5f8bxa9&page_limit=10&q=#{changed_title}")
				resp_unparsed = Net::HTTP.get_response(url)
				resp = JSON.parse resp_unparsed.body
				movies = resp["movies"]
				movie_rating = ""
				movie_id = ""
				movie_consensus = ""
				movie_title_forreal = ""
				movies.each do |movie|
					if movie["title"].downcase == real_movie_title.downcase
						movie_id = movie["id"]
						movie_rating = movie["ratings"]["critics_score"]
						movie_consensus = movie["critics_consensus"]
						movie_title_forreal = movie["title"]
					end
				end

				test_output = "http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=vzfnz8223sf79wn5x5f8bxa9&page_limit=10&q=#{changed_title}"



				url = URI.parse('https://api.groupme.com/v3/bots/post')
				if movie_title_forreal.blank?
					post_args = {"bot_id" => '87bd4bf2d3fad44c47c534ab36', "text" => "Sorry, I couldn't find anything on the movie."}.to_json
				else
					post_args = {"bot_id" => '87bd4bf2d3fad44c47c534ab36', "text" => "No problem. According to Rotten Tomatoes, #{movie_title_forreal} got a rating of #{movie_rating}%. #{movie_consensus}"}.to_json
				end
				a = ActiveSupport::JSON.decode(post_args)
				resp, data = Net::HTTP.post_form(url, a)
			elsif text == 'kanye next train to sf'
				#insert stuff here
				times = ""
				url = URI.parse("http://api.bart.gov/api/etd.aspx?cmd=etd&orig=wdub&key=MW9S-E7SL-26DU-VV8V&dir=s")
				resp_temp = Net::HTTP.get_response(url).body
				xml_data = REXML::Document.new(resp_temp)
				leaving_times = []
				xml_data.elements.each('root/station/etd/estimate/minutes') do |time| 
					leaving_times << time.text
				end
				leaving_times_length = leaving_times.length
				if leaving_times_length == 1
					times = "#{leaving_times[0]}"
				else
					for i in 0..leaving_times.length-1
						if i == leaving_times.length-1
							times << "and #{leaving_times[i]}"
						else
							times << "#{leaving_times[i]}, "
						end
					end
				end
				url = URI.parse('https://api.groupme.com/v3/bots/post')
				post_args = {"bot_id" => '87bd4bf2d3fad44c47c534ab36', "text" => "Trains leaving West Dublin station for San Francisco arriving in #{times} minutes."}.to_json
				a = ActiveSupport::JSON.decode(post_args)
				resp, data = Net::HTTP.post_form(url, a)
			elsif text == 'kanye did the a\'s win'
				url = URI.parse("http://partner.mlb.com/partnerxml/gen/news/rss/oak.xml")
				resp_temp = Net::HTTP.get_response(url)
				xml_data = REXML::Document.new(resp_temp)
				xml_data.elements.each('description') do |desc| 
					#if /\d-\d.{0,30}(victory|win)/.match(desc) != nil
						url = URI.parse('https://api.groupme.com/v3/bots/post')
						post_args = {"bot_id" => '87bd4bf2d3fad44c47c534ab36', "text" => "#{desc}"}.to_json
						a = ActiveSupport::JSON.decode(post_args)
						resp, data = Net::HTTP.post_form(url, a)
						break
					#end
				end
			end
		end
	end
end
