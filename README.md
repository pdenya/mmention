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

	login in incognito window as paul@pressfriendly.com to https://bigquery.cloud.google.com

	https://bigquery.cloud.google.com/queries/mmention-v2
	- query and export to table, allow large queries

	- export table
		- CSV, GZip, mmention/201510-*.csv.gzip

	https://console.developers.google.com/project/mmention-v2/storage/browser/mmention/
	 - download and unzip them all

	cat ~/Downloads/*.csv > ~/Downloads/mmention.csv

	iruby notebook
	run the import cell
	last result for 1.5gb csv:
		{
		  "total": 4282070,
		  "total_imported": 70668,
		  "seconds": 1539,
		  "minutes": 25
		}

## Pushing to Heroku

	heroku pg:reset DATABASE_URL
	heroku pg:push mmention DATABASE_URL

## Pulling from Heroku
	
	dropdb mmention
	heroku pg:pull DATABASE_URL mmention

