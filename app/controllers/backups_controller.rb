class BackupsController < ApplicationController
	def index
		@backups = current_user.backups.includes(:source_connector, :destination_connector)
	end

	def new
		@backup = Backup.new
		@connectors = current_user.connectors.all
	end

	def create
		@backup = Backup.new(backup_params)
		current_user.backups << @backup
			if @backup.save
				if params[:commit] == "Backup now"
					backup_now
				end
				redirect_to '/backups/index'
			else
				redirect_to '/backups/new'
			end
	end

	def backup_now
		@backup.backup
		@backup.source_connector.connection.close
		@backup.destination_connector.connection.close
	end

	private
	def backup_params
		params.require(:backup).permit(:source_connector_id, :destination_connector_id, :frequency, :item)
	end
end
