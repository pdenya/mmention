class Video < ActiveRecord::Base
	has_many :references
	has_many :comments, :through => :references
	
	def embed_url
		self.url.gsub(/\/watch\?v=/, '/embed/')
	end
end
