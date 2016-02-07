class Backup < ActiveRecord::Base
	belongs_to	:user
	belongs_to	:transfer
	has_many	:backup_histories

	before_create :set_next_backup_date

# Allows scheduling a transfer. 

	def log_backup(status, start_time, end_time)
		log_entry = BackupHistory.new ()
		log_entry.user_id = self.user_id
		log_entry.backup_id = self.id
		log_entry.status =  status
		log_entry.item_name = self.item
		log_entry.item_size = ""
		log_entry.backup_start_time = start_time
		log_entry.backup_end_time = end_time
		log_entry.source_connector_id = self.source_connector_id
		log_entry.destination_connector_id = self.destination_connector_id
		log_entry.save
	end

	def set_next_backup_date
		self.next_backup_date = Date.today
	end
end