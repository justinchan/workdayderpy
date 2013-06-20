class ManualController < ApplicationController
	def index
	end

	def post
		require 'net/http'
		require 'json'
		message = params[:kanye][:text]
		url = URI.parse('https://api.groupme.com/v3/bots/post')
		post_args = {"bot_id" => '87bd4bf2d3fad44c47c534ab36', "text" => "#{message}"}.to_json
		a = ActiveSupport::JSON.decode(post_args)
		resp, data = Net::HTTP.post_form(url, a)
		redirect_to manual_path
	end
end
