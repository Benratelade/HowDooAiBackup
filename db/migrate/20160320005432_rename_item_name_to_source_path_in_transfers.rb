class RenameItemNameToSourcePathInTransfers < ActiveRecord::Migration
  def change
  	rename_column :transfers, :item_name, :source_path
  end
end
