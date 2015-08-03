class VideosController < ApplicationController

	def index
		page = params[:page] ? (params[:page].to_i - 1) : 0
		@references = Reference.includes(:video).select('video_id, count(*) as count').group('video_id').order('count(*) DESC').limit(10).offset(10*page)

		@vid_by_sub = {}
		Comment.select('comments.subreddit, "references".video_id AS reference_video_id').joins('INNER JOIN "references" ON comments.id = "references".comment_id').where('video_id IN (?)', @references.map {|r| r.video_id }).each do |comment|
			@vid_by_sub[comment.reference_video_id] ||= []
			@vid_by_sub[comment.reference_video_id] << comment.subreddit unless @vid_by_sub[comment.reference_video_id].include?(comment.subreddit)
		end
	end

	def show
		@video = Video.find(params[:video_id])
	end
end