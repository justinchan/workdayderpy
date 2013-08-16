class FotosController < ApplicationController
	def index
		@pictures = Picture.all
	end
end
