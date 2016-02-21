class AddTypeToBackups < ActiveRecord::Migration
  def change
  	add_column :backups, :type, :string
  end
end
