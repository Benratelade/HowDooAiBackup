class Transfer < ActiveRecord::Base
	belongs_to	:source_connector, class_name: "Connector"
	belongs_to	:destination_connector, class_name: "Connector"
	belongs_to 	:user

	has_many	:transfer_logs

	scope :backups, -> { where(type: 'Backup') } 
	validates	:source_connector, uniqueness: {scope: [:destination_connector, :user, :source_path, :type]}
	validates	:source_connector, :destination_connector, :type, presence: true
	validates 	:source_path, presence: { message: "cannot be empty." }

	# Use this method to Patherize a string
	def get_destination_path 
		Pathname.new(self.destination_path)
	end

	def get_source_path
		Pathname.new(self.source_path)
	end

	def transfer
		attributes = {}
		attributes[:start_time] =  Time.now
		begin 
			download_path = self.source_connector.download_and_close(self.source_path)
			self.destination_connector.upload_and_close(download_path)
			attributes[:end_time] = Time.now
			attributes[:status] = "Transfer successful"
			log_transfer(attributes)
			self.save
		rescue Net::FTPError => e 
			attributes[:status] =  "Transfer failed: " + e.message
			log_transfer(attributes)
			self.save
		end
		return attributes
	end
	# handle_asynchronously :transfer

	def self.select_options
  		descendants.map{ |c| c.to_s }.sort << self.name
	end

	def log_transfer(attributes={})
		log_entry = TransferLog.create ({
			user_id: self.user_id, 
			transfer_id: self.id, 
			status: attributes[:status], 
			source_path: self.source_path, 
			item_size: "", 
			backup_start_time: attributes[:start_time], 
			backup_end_time: attributes[:end_time],
			source_connector_id: self.source_connector_id,
			destination_connector_id: self.destination_connector_id, 
			transfer_type: self.type
		})
		self.transfer_logs << log_entry
	end
end
