class Processors::BaseProcessor
	def self.put_obj data, name
		transfers_api = Integrations::AmazonWebServices::Gateway.new
		transfers_api.init

		transfers_api.put_obj(data,name)
	end
end