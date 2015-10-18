class RenameSourceConnectorToSourceConnectorIdInBackups < ActiveRecord::Migration
  def change
  	rename_column :backups, :source_connector, :source_connector_id
  	rename_column :backups, :destination_connector, :destination_connector_id
  end
end
