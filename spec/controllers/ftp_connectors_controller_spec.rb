require 'rails_helper'

RSpec.describe FtpConnectorsController, type: :controller do
	let(:valid_attributes) { { 	
			username: "thelocalpress",
			password: "ghourdy123$",
			host: "103.18.109.102",
			port: "21"
		}
	}

	let(:valid_session) {{ }}
	before(:each) do 
		create(:user)
		allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(User.first)
	end

	describe "GET #new" do
		it "displays the form to create a new FtpConnector" do
			get :new
			expect(response).to render_template("new")
		end
	end

	describe "POST #create" do
		it "saves a new FtpConnector to the database" do
			expect { post :create, {ftp_connector: valid_attributes}, valid_session}.to change(FtpConnector, :count).by(1)
		end

		it "saves a new FtpConnector as a Connector to the database" do
			expect { post :create, {ftp_connector: valid_attributes}, valid_session}.to change(Connector, :count).by(1)
		end

		it "redirects to the list of FtpConnectors" do
			post :create, {ftp_connector: valid_attributes}, valid_session
			expect(response).to redirect_to("/ftp_connectors/index")
		end
	end

	describe "GET #index" do 
		it 'assigns all FtpConnectors to @ftp_connectors'  do
			ftp_connector = create(:ftp_connector, user_id: controller.current_user.id)
			get :index, {}, valid_session
			expect(assigns(:ftp_connectors)).to eq([ftp_connector])
		end
		
		pending "only displays the current user's connectors" 

		it "displays the template with all FtpConnectors" do
			post :index, {}, valid_session
			expect(response).to render_template("index")
		end
	end
end
