class VideosController < ApplicationController

	def index
		page = params[:page] ? (params[:page].to_i - 1) : 0
		@references = Reference.includes(:video).select('video_id, count(*) as count').group('video_id').order('count(*) DESC').limit(10).offset(10*page)
	end

	def show
		@video = Video.find(params[:video_id])
	end
end