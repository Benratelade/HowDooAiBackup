class Connector < ActiveRecord::Base
	belongs_to :user
	has_many	:backups

	validates_presence_of :user_id
	validates :name, uniqueness: {scope: [:user_id]}

	def download_item(item)
	end

	def upload_item(item)
	end

	def list_items
	end

	def self.select_options
	  descendants.map{ |c| c.to_s }.sort
	end


	private
	def move_to_download_location
		rails_path = Rails.root.to_s
		Dir.chdir(rails_path + '/temp/downloads/') 
	end

	def create_download_folder
		folder_name = ''
		timestamp = Time.now.to_s
		folder_name += self.user.email + "-"+ self.username + "-" + timestamp
		Dir.mkdir(folder_name)
		return(folder_name)
	end

	def initiate_download
		puts "initiating download"
		move_to_download_location
		Dir.chdir(create_download_folder)
		@download_directory = Dir.getwd
	end
end
