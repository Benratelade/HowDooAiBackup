class Transfer < ActiveRecord::Base
	belongs_to	:source_connector, class_name: "Connector"
	belongs_to	:destination_connector, class_name: "Connector"
	belongs_to 	:user

	has_many	:transfer_logs

	scope :backups, -> { where(type: 'Backup') } 
	validates	:source_connector, uniqueness: {scope: [:destination_connector, :user, :item_name]}
	validates	:source_connector, :destination_connector, :type, presence: true
	validates 	:item_name, presence: { message: "cannot be empty." }

	def transfer
		attributes = {}
		attributes[:start_time] =  Time.now
		begin 
			download_path = self.source_connector.download_and_close(self.item_name)
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
	handle_asynchronously :transfer

	def self.select_options
  		descendants.map{ |c| c.to_s }.sort << self.name
	end

	def log_transfer(attributes={})
		log_entry = TransferLog.create ({
			user_id: self.user_id, 
			backup_id: self.id, 
			status: attributes[:status], 
			item_name: self.item_name, 
			item_size: "", 
			backup_start_time: attributes[:start_time], 
			backup_end_time: attributes[:end_time],
			source_connector_id: self.source_connector_id,
			destination_connector_id: self.destination_connector_id
		})
	end
end
