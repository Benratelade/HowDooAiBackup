class ChangeTransferFrequencyTypeInTransfers < ActiveRecord::Migration
  def change
  	change_column :transfers, :frequency, :string
  	add_column :transfer_logs, :type, :string
  end
end
