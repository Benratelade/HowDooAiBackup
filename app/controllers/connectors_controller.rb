class ConnectorsController < ApplicationController

	before_action :require_user, only: [:index, :new, :create]

	def new
		@connector = Connector.new
	end

	def create
		connector = current_user.connectors.new(connector_params)
		if connector.save
			redirect_to '/connectors/index'
		else
			redirect_to '/connectors/create'
		end
	end

	def index
		@connectors = current_user.connectors.all
	end

	def list_items
		connector = Connector.find_by_id(params[:id])
		@list = connector.list_items
		render json: @list
	end

	private
	def connector_params
		params.require(:connector).permit(:username, :password)
	end
end
