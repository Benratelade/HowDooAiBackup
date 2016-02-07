class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
		t.integer		:user_id
		t.integer		:source_connector_id
		t.integer		:destination_connector_id
		t.string		:item_name
		t.string		:destination_path
     	t.timestamps null: false
    end

    drop_table :backup_logs
    drop_table :scheduled_backups

    change_table :backups do |t|
    	t.remove 	:source_connector_id, :destination_connector_id, :item
    	t.integer	:transfer_id
    end
  end
end
