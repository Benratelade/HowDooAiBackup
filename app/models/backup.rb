class Backup < ActiveRecord::Base
	has_one		:source_connector, class_name: "Connector"
	has_one		:destination_connector, class_name: "Connector"
	belongs_to	:user

	def backup
		download_path = self.source_connector.download_item(self.item)
		self.destination_connector.upload_item(download_path)
	end
	handle_asynchronously :backup
end
