class AddItemToBackupToBackups < ActiveRecord::Migration
  def change
    add_column :backups, :item, :string
  end
end
