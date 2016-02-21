class RenameBackupHistoryIntoTransferLogs < ActiveRecord::Migration
  def change
  	rename_table :backup_histories, :transfer_logs
  	rename_column :transfer_logs, :backup_id, :transfer_id
  end
end
