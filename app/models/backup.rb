class Backup < ActiveRecord::Base
	belongs_to	:user
	belongs_to	:transfer
	has_many	:backup_histories

	before_create :set_next_backup_date

# Allows scheduling a transfer. 
	def execute_transfer
		attributes = self.transfer.transfer
		self.last_backup_date = Date.today
		set_next_backup_date
		self.save
		log_transfer(attributes)
	end

	def log_transfer(attributes={})
		log_entry = BackupHistory.create ({
			user_id: self.user_id, 
			backup_id: self.id, 
			status: attributes[:status], 
			item_name: self.transfer.item_name, 
			item_size: "", 
			backup_start_time: attributes[:start_time], 
			backup_end_time: attributes[:end_time],
			source_connector_id: self.transfer.source_connector_id,
			destination_connector_id: self.transfer.destination_connector_id
		})
	end

	def set_next_backup_date
		self.next_backup_date = Date.today + self.frequency
	end
end