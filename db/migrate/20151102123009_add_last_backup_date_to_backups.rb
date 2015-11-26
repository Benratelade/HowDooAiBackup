class AddLastBackupDateToBackups < ActiveRecord::Migration
  def change
    add_column :backups, :last_backup_date, :date
  end
end
