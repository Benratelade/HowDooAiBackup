class ChangeFrequencyFromStringToIntegerInBackups < ActiveRecord::Migration
  def change
  	remove_column :backups, :frequency
  	add_column :backups, :frequency, :integer
  end
end
