class RemoveTransferIdFromBackups < ActiveRecord::Migration
  def change
  	remove_column :backups, :transfer_id
  end
end
