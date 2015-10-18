class AddConnectorIndexesToBackups < ActiveRecord::Migration
  def change
  	add_column	:backups, :source_connector, :integer
  	add_column	:backups, :destination_connector, :integer
  end
end
