class AddStatusToBackups < ActiveRecord::Migration
  def change
    add_column :backups, :status, :string
  end
end
