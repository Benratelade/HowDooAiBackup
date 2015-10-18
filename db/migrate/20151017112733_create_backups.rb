class CreateBackups < ActiveRecord::Migration
  def change
    create_table :backups do |t|
      t.string :frequency

      t.timestamps null: false
    end
  end
end
