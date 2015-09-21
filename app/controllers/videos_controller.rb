class VideosController < ApplicationController

	def index
		# get page, default to 1
		@page = params[:page] ? params[:page].to_i : 1

		# order by reference counts
		@references = Reference.includes(:video).select('video_id, count(*) as count').where('').group('video_id').order('count(*) DESC').limit(10).offset(10*(@page - 1))

		# particular subreddit only
		if params[:subreddit] && params[:subreddit] =~ /^[A-Za-z0-9_]+$/
			@references = @references.joins("INNER JOIN comments ON (\"references\".comment_id = comments.id AND comments.subreddit = '#{params[:subreddit]}' AND comments.posted_at > '#{60.days.ago.strftime('%Y-%m-%d')}')")
		else
			@references = @references.joins("INNER JOIN comments ON (\"references\".comment_id = comments.id AND comments.posted_at > '#{60.days.ago.strftime('%Y-%m-%d')}')")
		end

		# organize by sub
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