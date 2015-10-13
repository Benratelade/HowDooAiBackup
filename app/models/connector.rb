class Connector < ActiveRecord::Base
	belongs_to :customer

	validates_presence_of :user_id
end
