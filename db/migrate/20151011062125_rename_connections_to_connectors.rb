class RenameConnectionsToConnectors < ActiveRecord::Migration
  def change
  	rename_table "connections", "connectors"
  end
end
