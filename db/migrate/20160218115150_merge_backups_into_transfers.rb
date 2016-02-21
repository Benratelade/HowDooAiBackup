class MergeBackupsIntoTransfers < ActiveRecord::Migration
  def change
  	add_column :transfers, :type, :string
  	add_column :transfers, :next_backup_date, :date
  	add_column :transfers, :last_backup_date, :date
  	add_column :transfers, :frequency, :integer
  	
  	drop_table :backups
  end
end
