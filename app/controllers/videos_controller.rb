class VideosController < ApplicationController

	def index
		setup_context		
	end

	def show
		@video = Video.find(params[:video_id])
	end

	def game
		games = {
			"leagueoflegends" => ["leagueoflegends","summonerschool"],
			"heroesofthestorm" => ['heroesofthestorm', 'nexusnewbies', 'competitivehots']
		}

		@subreddits = games[params[:game].downcase]

		@game = params[:game].downcase if @subreddits.present?

		setup_context

		render "index"
	end

	def setup_context
		# get page, default to 1
		@page = params[:page] ? params[:page].to_i : 1

		# order by reference counts
		@references = Reference.includes(:video).select('video_id, count(*) as count').where('').group('video_id').order('count(*) DESC').limit(10).offset(10*(@page - 1))
		@references = @references.joins("INNER JOIN comments ON (\"references\".comment_id = comments.id AND comments.posted_at > '#{60.days.ago.strftime('%Y-%m-%d')}')")
		@subreddits ||= params[:subreddit].downcase.split('+') if params[:subreddit]

		# particular subreddit only
		if @subreddits
			@references = @references.where("comments.subreddit IN (?)", @subreddits)
		end

		# organize by sub
		@subs_mentioning_video = {}
		Comment.select('comments.subreddit, "references".video_id AS reference_video_id').joins('INNER JOIN "references" ON comments.id = "references".comment_id').where('video_id IN (?)', @references.map {|r| r.video_id }).each do |comment|
			@subs_mentioning_video[comment.reference_video_id] ||= []
			@subs_mentioning_video[comment.reference_video_id] << comment.subreddit unless @subs_mentioning_video[comment.reference_video_id].include?(comment.subreddit)
		end
	end
end