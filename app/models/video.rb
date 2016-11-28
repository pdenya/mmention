class Video < ActiveRecord::Base
	has_many :references
	has_many :comments, :through => :references
	
	def embed_url
		self.youtube_url.gsub(/\/watch\?v=/, '/embed/')
	end

	def youtube_url
		"https://www.youtube.com/watch?v=#{self[:url]}"
	end

	def preview_image_url
		"//i.ytimg.com/vi/#{self[:url]}/hqdefault.jpg"
	end
end
