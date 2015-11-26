class AddNextBackupDateToBackups < ActiveRecord::Migration
  def change
  	add_column :backups, :next_backup_date, :date
  end
end
