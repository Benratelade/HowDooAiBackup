require 'rails_helper'

RSpec.describe ConnectorsController, type: :controller do

	let(:valid_attributes) {
		{ username: 'thelocalpress', password: 'ghourdy123$' }
	}

	let(:valid_session) {{ }}
	before(:each) do 
		create(:user)
		allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(User.first)
	end

	describe 'GET #new' do
	    it "assigns a new connector as @connector" do
		    get :new, {}, valid_session
	    	expect(assigns(:connector)).to be_a_new(Connector)
	    end
		it "displays the form to create a new connector" do
			get :new, valid_session
			expect(response).to render_template(:new)
		end
	end

	describe 'POST #create' do
		it 'saves the new connector to the database' do
			expect { post :create, {connector: valid_attributes}, valid_session}.to change(Connector, :count).by(1)
		end
		it 'associates the newly created connector to the currently logged in user' do
			post :create, {connector: valid_attributes}, valid_session
			connector = Connector.first
			expect(connector.user_id).to eql(controller.current_user.id)
		end

		it 'redirects to the list of connectors' do 
			post :create, { connector: valid_attributes }, valid_session
			expect(response).to redirect_to("/connectors/index")
		end
	end

	describe 'GET #index' do 
		it 'assigns all connectors to @connectors'  do
			connector = create(:connector, user_id: controller.current_user.id)
			get :index, {}, valid_session
			expect(assigns(:connectors)).to eq([connector])
		end

		it 'renders the index page' do 
			get :index, {}, valid_session
			expect(response).to render_template("index")
		end
	end
end