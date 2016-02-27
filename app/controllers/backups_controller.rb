class BackupsController < ApplicationController
	
	before_action :require_user, only: [:index, :new, :create]

	def index
		@backups = current_user.backups
		@transfers = current_user.transfers.where.not(type: "Backup")
	end

	def new
		@backup = Backup.new
	end

	def create
	end

	private
end
