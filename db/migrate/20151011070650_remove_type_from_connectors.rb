class RemoveTypeFromConnectors < ActiveRecord::Migration
  def change
  	remove_column :connectors, :type
  end
end
