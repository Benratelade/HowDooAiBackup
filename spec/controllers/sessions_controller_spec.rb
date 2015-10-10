require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
	let(:valid_attributes) { { email: 'ratelade.benjamin@gmail.com', password: 'qwert123$' } }

	let(:invalid_attributes) { 
		{ email: 'joe.blogg@google.com', password: 'shoe' } 
	}

	let(:valid_session) { { } }

	describe 'GET#new' do
		it 'displays the login page' do
			get :new
			expect(response).to render_template(:new)
		end
	end
	
	describe 'POST#create' do
		context 'when password is valid' do
			it 'records the current user as being logged in' do
				user = create(:user)
				post :create, session: {email: user.email, password: user.password}
				expect(response).to redirect_to("/")
				expect(controller.current_user).to eq(user)
			end
			# it 'redirects to home page' do
				
			# end
		end
		context 'when password is invalid' do
			it 'redirects to login page if login was invalid' do
				user = create(:user)
				post :create, session: invalid_attributes
				expect(response).to redirect_to("/login")
			end
		end
	end

	describe 'DELETE#destroy' do
		it 'logs out the current user' do
			delete :destroy if controller.current_user
			expect(session[:user_id]).to eq(nil)
		end
	end
end
