require 'aws-sdk'

class Integrations::AmazonWebServices::Gateway < Integrations::StorageApi

	def init
		@s3 = Aws::S3::Resource.new(
			region:'us-east-1', 
			access_key_id: AMAZON_ACCESS_KEY_ID, 
			secret_access_key: AMAZON_SECRET_ACCESS_KEY
		)
	end

	def put_obj(data, name)
		obj = @s3.bucket('howdooai.backupapp.storage').object(name)
		obj.put(body: data)
	end
end