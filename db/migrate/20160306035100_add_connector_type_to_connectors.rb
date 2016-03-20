class AddConnectorTypeToConnectors < ActiveRecord::Migration
  def change
  	add_column :connectors, :connector_type, :string
  end
end
