class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
    	t.string :type
    	t.string :username
    	t.string :password_digest
     	t.timestamps null: false
    end
  end
end
