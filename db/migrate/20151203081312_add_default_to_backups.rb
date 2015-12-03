class AddDefaultToBackups < ActiveRecord::Migration
  def change
  	change_column_default :backups, :frequency, 7
  end
end
