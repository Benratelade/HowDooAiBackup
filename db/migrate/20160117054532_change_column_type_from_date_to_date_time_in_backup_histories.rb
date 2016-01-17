class ChangeColumnTypeFromDateToDateTimeInBackupHistories < ActiveRecord::Migration
  def change
  	
  	reversible do |dir|
  		dir.up do
  			change_column :backup_histories, :backup_start_time, :datetime
  			change_column :backup_histories, :backup_end_time, :datetime
  		end

  		dir.down do 
  			change_column :backup_histories, :backup_start_time, :date
  			change_column :backup_histories, :backup_end_time, :date
  		end
  	end
  end
end
