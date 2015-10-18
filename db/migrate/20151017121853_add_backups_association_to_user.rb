class AddBackupsAssociationToUser < ActiveRecord::Migration
  def change
  	add_reference :backups, :user
  end
end
