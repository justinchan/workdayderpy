desc "Do the tabulation"
task :tabulate do 
	require 'net/http'
	require 'json'
	url = URI.parse('https://api.groupme.com/groups/4600386/messages?token=ab32b920b6940130a343663e2468da7d')
	resp_unparsed = Net::HTTP.get_response(url)
	resp = JSON.parse resp_unparsed.body
	resp = resp["response"]
	count = resp["count"]
	messages = resp["messages"]
	top_chatter = Hash.new{|h,k| h[k] = 0}
	not_done_yet = true
	running_count = 0
	message_id = 0
	messages.each do |message|
		running_count +=1
		user = message["name"]
		top_chatter[user] +=1
		message_id = message["id"]
	end
	while(not_done_yet)
		url = URI.parse("https://api.groupme.com/groups/4600386/messages?token=ab32b920b6940130a343663e2468da7d&before_id=#{message_id}")
		resp_unparsed = Net::HTTP.get_response(url)
		resp = JSON.parse resp_unparsed.body
		resp = resp["response"]
		messages = resp["messages"]
		messages.each do |message|
			running_count += 1
			user = message["name"]
			top_chatter[user] +=1
			message_id = message["id"]
		end
		if running_count == count
			not_done_yet = false
		end
	end
	winner_pair = top_chatter.max_by{|k,v| v}
	winner_name = winner_pair[0]
	winner_value = winner_pair[1]
	top_chatter[winner_name] = 0
	second_place = top_chatter.max_by{|k,v| v} 
	second_name = second_place[0]
	second_value = second_place[1]
	top_chatter[winner_name] = 0
	third_place = top_chatter.max_by{|k,v| v} 
	third_name = third_place[0]
	third_value = third_place[1]



	url = URI.parse('https://api.groupme.com/v3/bots/post')
	post_args = {"bot_id" => '87bd4bf2d3fad44c47c534ab36', "text" => "#{count} total messages. I counted #{running_count}. Winner: #{winner_name} with #{winner_value} messages. Second place: #{second_name} with #{second_value} messages. Third place: #{third_name} with #{third_value} messages."}.to_json
	a = ActiveSupport::JSON.decode(post_args)
	resp, data = Net::HTTP.post_form(url, a)
end