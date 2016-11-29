## MMention

http://mmention.com is a way to quickly view the most recommended videos in a few select subreddits.  It came about easily because google cloud query has an archive of all reddit comments in every sub organized by month.

MMention.com is currently game focused with videos aggregated for 15 popular games.  The framework will work for any subreddit that we import.

## Pages

The root page has all videos for all imported subreddits, ordered by times mentioned

![Github icon](https://raw.githubusercontent.com/pdenya/mmention/master/public/images/screenshots/index.jpg)

The games pages (eg: http://mention.com/games/leagueoflegends) show videos from multiple game related subreddits, ordered by times mentioned.  Subreddit specific pages are also available (eg: http://mmention.com/r/summonerschool)

![Github icon](https://raw.githubusercontent.com/pdenya/mmention/master/public/images/screenshots/sub.jpg)

Video pages (eg: http://mmention.com/v/2243) have a larger video with the top 20 reddit comments (by reddit upvotes) embedded on the page

![Github icon](https://raw.githubusercontent.com/pdenya/mmention/master/public/images/screenshots/video.jpg)


## The Big Data Query

	SELECT
	  author,
	  body,
	  score,
	  name,
	  link_id,
	  created_utc,
	  subreddit_id,
	  subreddit,
	  gilded,
	  id
	FROM
	  TABLE_QUERY([fh-bigquery:reddit_comments], "table_id CONTAINS '2015' AND LENGTH(table_id)<8")
	WHERE
	  body CONTAINS 'youtube.com/' OR body CONTAINS 'youtu.be/';

## New Data Process

	login to https://bigquery.cloud.google.com

	create a project, eg: mmention-v2 (requires a billing enabled project even though this is free)

	https://bigquery.cloud.google.com/queries/mmention-v2
	- query and export to table, allow large queries

	https://console.cloud.google.com
	- create a bucket we can export all that data into, eg: mmention

	- export table
		- CSV, GZip
		- cloud url format: mmention/201610-*.csv.gzip (* is because it will have to be split into multiple files)

	https://console.developers.google.com/project/mmention-v2/storage/browser/mmention/
	 - download and unzip them all

	`cat ~/Downloads/*.csv > ~/Downloads/mmention.csv`
	move mmention.csv to the root of the rails project

	
	`rails console`
	`CommentImporter.import_games` 
	or 
	`CommentImporter.import(csvfile: 'mmention.csv', import_subs: ['whatever', 'subreddits', 'you_want_to_import', 'eg', 'leagueoflegends'])`

	last result for 1.5gb csv:
		{
			:total => 5015134, 
			:total_imported => 234596, 
			:seconds => 9341, 
			:minutes => 155
		}

### Export local database

	pg_dump -h localhost mmention > mmention.pgsql

### Import remote database
	
	psql -h localhost -U rails mmention_prod < mmention.pgsql
