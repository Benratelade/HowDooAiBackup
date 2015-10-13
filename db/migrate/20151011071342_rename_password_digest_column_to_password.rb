class RenamePasswordDigestColumnToPassword < ActiveRecord::Migration
  def change
  	rename_column :connectors, :password_digest, :password
  end
end
