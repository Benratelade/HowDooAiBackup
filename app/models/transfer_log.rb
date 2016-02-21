class TransferLog < ActiveRecord::Base
	belongs_to	:transfer
	belongs_to	:user
	belongs_to	:source_connector, class_name: "Connector"
	belongs_to	:destination_connector, class_name: "Connector"


end
