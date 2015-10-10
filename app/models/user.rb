class User < ActiveRecord::Base
	has_secure_password

	validates :email, uniqueness: true, email_format:  {message: 'Something doesn\'t look right'}
end
