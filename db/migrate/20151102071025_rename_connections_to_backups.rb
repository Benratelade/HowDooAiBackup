class RenameConnectionsToBackups < ActiveRecord::Migration
  def change
  	rename_table :connections, :backups
  end
end
