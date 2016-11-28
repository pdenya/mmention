class Comment < ActiveRecord::Base

	def full_thread_url
		"http://reddit.com/r/#{self[:subreddit]}/comments/self[:thread_url]"
	end

	def full_comment_url
		"#{self.full_thread_url}/a/#{self[:remote_id]}"
	end
end
