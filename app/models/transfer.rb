class Transfer < ActiveRecord::Base
	belongs_to	:source_connector, class_name: "Connector"
	belongs_to	:destination_connector, class_name: "Connector"
	belongs_to 	:user

	def transfer
		attributes = {}
		attributes[:start_time] =  Time.now
		begin 
			download_path = self.source_connector.download_and_close(self.item_name)
			self.destination_connector.upload_and_close(download_path)
			attributes[:end_time] = Time.now
			attributes[:status] = "Transfer successful"
			log_transfer(attributes)
			# self.last_backup_date = Date.today
			# self.next_backup_date = Date.today + self.frequency
			self.save
		rescue Net::FTPError => e 
			attributes[:status] =  "Transfer failed: " + e.message
			log_transfer(attributes)

			self.save
		end
		return attributes
	end
	# handle_asynchronously :backup


	def log_transfer(attributes={})
		log_entry = BackupHistory.new ()
		log_entry.user_id = self.user_id
		log_entry.backup_id = self.id
		log_entry.status =  attributes[:status]
		log_entry.item_name = self.item_name
		log_entry.item_size = ""
		log_entry.backup_start_time = attributes[:start_time]
		log_entry.backup_end_time = attributes[:end_time]
		log_entry.source_connector_id = self.source_connector_id
		log_entry.destination_connector_id = self.destination_connector_id
		log_entry.save
	end
end
