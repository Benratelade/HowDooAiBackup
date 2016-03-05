class Processors::TransferProcessor < Processors::Base
	def process_transfer(transfer)
		source_api_name = "Integrations::#{transfer.source_connector.connector_type}::Gateway"
		destination_api_name = "Integrations::#{transfer.destination_connector.connector_type}::Gateway"
		source_api = source_api_name.constantize.new
		destination_api = destination_api_name.constantize.new

		source_api.download(transfer.item) do |data|
			destination_api.upload(data)
		end
	end

	def list_items(connector, destination)

	end

	def get_gateway(connector)
		api_name = "Integrations::#{connector.connector_type}::Gateway"
		api = api_name.constantize.new
	end
end