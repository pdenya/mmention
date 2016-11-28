class VideosController < ApplicationController

	def index
		setup_context		
	end

	def show
		@video = Video.find(params[:video_id])
		@comments = @video.comments.where('score > 0').order('score DESC').limit(20)
		subreddit = @comments.first[:subreddit]

		self.game_list.each do |game,subs|
			if subs.include?(subreddit)	
				@game = game
				break
			end
		end
	end

	def game
		setup_context

		render "index"
	end

	def game_list
		{
			"leagueoflegends" => ["leagueoflegends","summonerschool","loleventvods"],
			"heroesofthestorm" => ['heroesofthestorm', 'nexusnewbies', 'competitivehots'],
			"overwatch" => ['overwatch', 'blackwatch'],
			"wow" => ['wow', 'wownoob'],
			"diablo" => ['diablo', 'diablo3'],
			"starcraft" => ['starcraft'],
			"hearthstone" => ['hearthstone'],
			"dota2" => ['dota2','learndota2'],
			"smite" => ['smite', 'smitetraining'],
			"heroesofnewerth" => ['heroesofnewerth'],
			"vainglory" => ['vainglorygame'],
			"battleborn" => ['battleborn'],
			"csgo" => ['globaloffensive','learncsgo'],
			"tf2" => ['tf2','newtotf2','truetf2'],
			"minecraft" => ['minecraft']
		}
	end

	def setup_context
		# get page, default to 1
		@page = params[:page] ? params[:page].to_i : 1

		# 
		games = game_list

		# order by reference counts
		@references = Reference.includes(:video).select('video_id, count(*) as count').where('videos.is_hidden = false').group('video_id').order('count(*) DESC').limit(10).offset(10*(@page - 1))
		#@references = @references.joins("INNER JOIN comments ON (\"references\".comment_id = comments.id AND comments.posted_at > '#{90.days.ago.strftime('%Y-%m-%d')}')")
		@references = @references.joins("INNER JOIN comments ON (\"references\".comment_id = comments.id)")
		@references = @references.joins("INNER JOIN videos ON (\"references\".video_id = videos.id)")
		@subreddits = params[:subreddit].downcase.split('+') if params[:subreddit]

		# setup game styles and such
		if params[:game]
			@subreddits = games[params[:game].downcase]
			@game = params[:game].downcase if @subreddits.present?
		elsif @subreddits.present?
			games.each do |game,subs|
				if subs.include?(@subreddits.first)	
					@game = game
				end
			end
		end

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