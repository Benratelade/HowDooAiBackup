class Transfer < ActiveRecord::Base
	belongs_to	:source_connector, class_name: "Connector"
	belongs_to	:destination_connector, class_name: "Connector"
	belongs_to 	:user

	def transfer
		start_time = Time.now
		begin 
			download_path = self.source_connector.download_and_close(self.item_name)
			self.destination_connector.upload_and_close(download_path)
			end_time = Time.now
			log_transfer( "Transfer successful", start_time, end_time )
			# self.last_backup_date = Date.today
			# self.next_backup_date = Date.today + self.frequency
			self.save
		rescue Net::FTPError => e 
			error = "Transfer failed: " + e.message
			log_transfer(error, start_time, Time.now)
			# self.next_backup_date = Date.today + 1

			self.save
		end
	end
	# handle_asynchronously :backup


	def log_transfer(status, start_time, end_time)
		log_entry = BackupHistory.new ()
		log_entry.user_id = self.user_id
		log_entry.backup_id = self.id
		log_entry.status =  status
		log_entry.item_name = self.item_name
		log_entry.item_size = ""
		log_entry.backup_start_time = start_time
		log_entry.backup_end_time = end_time
		log_entry.source_connector_id = self.source_connector_id
		log_entry.destination_connector_id = self.destination_connector_id
		log_entry.save
	end
end
