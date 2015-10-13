class AddFtConnectorsToConnectors < ActiveRecord::Migration
  def change
  	add_column :connectors, :type, :string
  	add_column :connectors, :host, :string
  	add_column :connectors, :port, :int
  end
end
