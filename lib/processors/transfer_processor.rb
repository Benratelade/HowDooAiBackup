class Processors::TransferProcessor < Processors::BaseProcessor
	def self.process_transfer(transfer)
		source_api = get_gateway(transfer.source_connector)
		destination_api = get_gateway(transfer.destination_connector)

		upload_proc = destination_api.get_upload_proc(transfer.get_destination_path)
		source_api.get_item(transfer.get_source_path, upload_proc)
	end

	def self.list_items(connector, destination)

	end

	def self.get_gateway(connector)
		api_name = "Integrations::#{connector.connector_type}::Gateway"
		api = api_name.constantize.new
		api.init(connector)
		return api
	end
end