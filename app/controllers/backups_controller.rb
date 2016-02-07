class BackupsController < ApplicationController
	
	before_action :require_user, only: [:index, :new, :create]

	def index
		@backups = current_user.backups.includes(:transfer)
	end

	def new
		@backup = Backup.new
	end

	def create
	end

	private
end
