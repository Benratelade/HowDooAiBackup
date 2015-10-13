class AddingUserIdToConnectors < ActiveRecord::Migration
  def change
  	add_column :connectors, :user_id, :int
  end
end
