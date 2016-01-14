class CreateBackupHistories < ActiveRecord::Migration
  def change
    create_table :backup_histories do |t|
    	t.string 	:status
    	t.integer	:backup_id
		t.integer	:user_id
    	t.string	:item_name
    	t.string	:item_size
    	t.date		:backup_start_time
    	t.date		:backup_end_time
    	t.integer	:source_connector_id
    	t.integer	:destination_connector_id
    	t.timestamps null: false
    end
  end
end
