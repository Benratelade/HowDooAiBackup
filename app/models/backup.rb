class Backup < ActiveRecord::Base
	belongs_to	:source_connector, class_name: "Connector"
	belongs_to	:destination_connector, class_name: "Connector"
	belongs_to	:user
	has_many	:backup_histories

	def backup
		download_path = self.source_connector.download_item(self.item)
		self.destination_connector.upload_item(download_path)
		self.destination_connector.connection.close
		self.source_connector.connection.close
		self.last_backup_date = Date.today
		self.next_backup_date = Date.today + self.frequency
		self.save
	end
	# handle_asynchronously :backup
end
