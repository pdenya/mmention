class CommentImporter

	def self.import_games
		import_subs = [
			'heroesofthestorm',
			'nexusnewbies',
			'competitivehots',
			'leagueoflegends',
			'loleventvods',
			'summonerschool',
			'overwatch',
			'blackwatch',
			'wow',
			'wownoob',
			'diablo',
			'diablo3',
			'starcraft',
			'hearthstone',
			'dota2',
			'learndota2',
			'smite',
			'smitetraining',
			'heroesofnewerth',
			'vainglorygame',
			'battleborn',
			'globaloffensive',
			'learncsgo',
			'tf2',
			'newtotf2',
			'truetf2',
			'minecraft'
		]

		CommentImporter.import(import_subs: import_subs)
	end

	def self.import(csvfile: 'mmention.csv', import_subs: [])
		# import the leaguevids.csv file
		require 'cgi'
		require 'csv'

		url_regex = /\b(([\w-]+:\/\/?|www[.])[^\s()<>]+(?:\([\w\d]+\)|([^[:punct:]\s]|\/)))/
		i = 0
		j = 0
		t = Time.now.to_i
		skipped = {}

		CSV.foreach(csvfile, :headers => true) do |csv_obj|
			# count total rows
			i += 1
			
			# filter subreddits
			csv_obj['subreddit'].downcase!
			next unless import_subs.include?(csv_obj['subreddit'])
			
			# require fields
			skip = false
			['id','body','link_id','created_utc','subreddit','author', 'score'].each do |required_key|
				if csv_obj[required_key].nil?
					skip = true
					skipped[required_key] ||= 0
					skipped[required_key] += 1
				end
			end
			next if skip
			
			# check if we've processed this comment
			comment = Comment.where('remote_id = ?', csv_obj['id']).first
			next unless comment.nil?
			
			# count rows we're processing
			j += 1
			
			# find youtube.com urls
			youtube_urls = csv_obj['body'].gsub(/&amp;/, '&').scan(url_regex).map {|r| r.first}.select{|url| url.include?("://www.youtube.com/")}

			# normalize
			urls = youtube_urls.map do |url|
				params = CGI::parse(url.split('?').last) rescue nil
				next if params.nil? || !params['v'] || !params['v'].first

				# just keep youtube id
				params['v'].first
			end
			
			urls ||= []
			
			# find youtu.be urls
			youtube_urls = csv_obj['body'].gsub(/&amp;/, '&').scan(url_regex).map {|r| r.first}.select{|url| url.include?("://youtu.be/")}

			# normalize
			youtube_urls.each do |url|
				param = url.split('youtu.be/').last.split('?').first rescue nil
				next if param.nil?

				# just keep youtube id
				urls << param
			end
			
			# unique
			urls.uniq!
			
			# skip this comment if we didn't find any urls
			next if urls.empty?
			
			# insert
			comment = Comment.create({
				:thread_url => csv_obj['link_id'].split('_').last,
				:remote_id => csv_obj['id'],
				# not storing these for storage cost reasons
				#:url => "http://reddit.com/r/#{csv_obj['subreddit']}/comments/#{csv_obj['link_id'].split('_').last}/a/#{csv_obj['id']}", # we can just generate this out of the other pieces
				#:text => csv_obj['body'], # it'd be much much better for search, seo, etc to have this :(
				:user => csv_obj['author'],
				:posted_at => Time.at(csv_obj['created_utc'].to_i).to_datetime,
				:subreddit => csv_obj['subreddit'],
				:score => csv_obj['score']
			})
			
			# create video and reference objects
			urls.each do |url|
				vid = Video.where('url = ?', url).first
				
				vid ||= Video.create({
					:url => url
				})
				
				reference = Reference.create({
					:video => vid,
					:comment => comment
				})
			end
		end

		# return import stats
		t = Time.now.to_i - t
		{ :total => i, :total_imported => j, :seconds => t , :minutes => (t/60) }
	end

end