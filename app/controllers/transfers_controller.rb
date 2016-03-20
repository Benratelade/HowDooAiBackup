class TransfersController < ApplicationController
	
	before_action :require_user, only: [:index, :new, :create]

	def index
		@transfers = current_user.transfers.includes(:source_connector, :destination_connector)
	end

	def new
		@transfer = Transfer.new
		@connectors = current_user.connectors
	end

	def create
		@transfer = current_user.transfers.where(
			source_connector_id: transfers_params[:source_connector_id], 
			destination_connector_id: transfers_params[:destination_connector_id], 
			source_path: transfers_params[:source_path], 
			type: transfers_params[:type]
			).first
		if @transfer == nil
			@transfer = Transfer.new(transfers_params)
			current_user.transfers << @transfer
			can_proceed = @transfer.save
		else
			can_proceed = true
		end
		if can_proceed
			if @transfer.is_a? Backup
				@transfer.next_backup_date = Date.today
				if @transfer.save
					redirect_to '/backups/index' and return
				else 
					@connectors = current_user.connectors
					render :new
				end		 
			else
				puts "transferring now"
				transfer_now
				redirect_to '/backups/index' and return
			end		
		else
			@connectors = current_user.connectors
			render :new
		end	
	end

	def transfer_now
		Processors::TransferProcessor.process_transfer(@transfer)
	end

	private
	def transfers_params
		params.require(:transfer).permit(:source_connector_id, :destination_connector_id, :frequency, :source_path, :type)
	end
end
