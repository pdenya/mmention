class VideosController < ApplicationController

	def index
		@references = Reference.includes(:video).select('video_id, count(*) as count').group('video_id').order('count(*) DESC').limit(10).offset(10)
	end

	def show
		@video = Video.find(params[:video_id])
	end
end