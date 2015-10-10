class SessionsController < ApplicationController
	
	def new
	end

	def create
		@user = User.find_by_email(params[:session][:email])
		if @user && @user.authenticate(params[:session][:password])
			session[:user_id] = @user.id
			redirect_to '/'
		else
			flash[:alert] = "Verify email and password"
			redirect_to '/login'
		end
	end

	def destroy
		session.delete(:user_id)
		redirect_to '/'
	end
end
