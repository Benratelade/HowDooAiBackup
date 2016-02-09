class TransfersController < ApplicationController
	
	before_action :require_user, only: [:index, :new, :create]

	def index
		@transfers = current_user.transfers.includes(:source_connector, :destination_connector)
	end

	def new
		@transfer = Transfer.new
		@connectors = current_user.connectors.all
	end

	def create
		puts transfers_params
		@transfer = Transfer.new(transfers_params)
		current_user.transfers << @transfer
		if @transfer.save
			if params[:commit] == "Transfer now"
				transfer_now
				redirect_to '/backups/index'
			elsif params[:commit] == "Schedule backup"
				backup = Backup.new
				backup.transfer = @transfer
				current_user.backups << backup
				backup.next_backup_date = Date.today
				backup.frequency = 7
				if backup.save
					redirect_to '/backups/index' 
				else
					redirect_to '/transfers/new'
				end				
			else 
				redirect_to '/transfers/new'
			end
		end
	end

	def transfer_now
		@transfer.transfer
	end

	private
	def transfers_params
		params.require(:transfer).permit(:source_connector_id, :destination_connector_id, :frequency, :item_name)
	end
end
