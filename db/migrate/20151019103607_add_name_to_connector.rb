class AddNameToConnector < ActiveRecord::Migration
  def change
    add_column :connectors, :name, :string
  end
end
