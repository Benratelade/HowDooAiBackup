class FtpConnectorsController < ApplicationController
	def new
		@ftp_connector = FtpConnector.new
	end

	def create
		ftp_connector = FtpConnector.new(ftp_connector_params)
		if ftp_connector.name == nil
			ftp_connector.name == ftp_connector.host + ' / ' + ftp_connector.username 
		end
		current_user.connectors << ftp_connector
		if ftp_connector.save
			redirect_to "/ftp_connectors/index"
		else
			redirect_to "/ftp_connectors/new"
		end
	end

	def index
		@ftp_connectors = current_user.connectors.where(type: "FtpConnector")
	end

	private
	def ftp_connector_params
		params.require(:ftp_connector).permit(:name, :username, :password, :host, :port)
	end
end
