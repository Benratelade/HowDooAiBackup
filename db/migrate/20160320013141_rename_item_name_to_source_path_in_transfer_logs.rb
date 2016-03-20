class RenameItemNameToSourcePathInTransferLogs < ActiveRecord::Migration
  def change
  	rename_column :transfer_logs, :item_name, :source_path
  end
end
