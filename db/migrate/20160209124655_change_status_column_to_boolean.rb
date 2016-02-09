class ChangeStatusColumnToBoolean < ActiveRecord::Migration
  def change
  	remove_column :backups, :status
  	add_column	:backups, :queued, :boolean, default: false
  end
end
