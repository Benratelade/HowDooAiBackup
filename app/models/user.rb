class User < ActiveRecord::Base
	has_secure_password
	has_many	:connectors, dependent: :destroy
	has_many	:transfers, dependent: :destroy

	delegate :backups, to: :transfers
	validates :email, uniqueness: true, email_format:  {message: 'Something doesn\'t look right'}
end
