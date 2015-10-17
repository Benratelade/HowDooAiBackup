class Connector < ActiveRecord::Base
	belongs_to :customer

	validates_presence_of :user_id

	def download_item(item)
	end

	def upload_item(item)
	end

	private
	def move_to_download_location
		rails_path = Rails.root.to_s
		Dir.chdir(rails_path + '/temp/downloads/') 
	end

	def create_download_folder
		timestamp = Time.now.to_s
		Dir.mkdir(timestamp)
		return(timestamp)
	end

	def initiate_download
		move_to_download_location
		Dir.chdir(create_download_folder)
		@download_directory = Dir.getwd
	end
end
