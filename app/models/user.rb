class User < ActiveRecord::Base
	has_secure_password
	has_many :connectors, dependent: :destroy

	validates :email, uniqueness: true, email_format:  {message: 'Something doesn\'t look right'}
end
