class RenameTypeColumnToTransferTypeInTransferLogs < ActiveRecord::Migration
  def change
  	rename_column :transfer_logs, :type, :transfer_type
  end
end
