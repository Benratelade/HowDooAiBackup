require 'rails_helper'

RSpec.describe FtpConnector, type: :model do
	before(:all) do
		@ftp_connector = create(:ftp_connector)
		@ftp_connector.connect_to_server
		@download_location = 'temp/downloads/'
		@path = Dir.getwd
	end

	after(:all) do
		@ftp_connector.connection.close
	end
	after(:each) do
		Dir.chdir(@path)
	end

  describe '#connect_to_server' do
	it "Initiates an Ftp connection to the server in @connection" do 
		expect(@ftp_connector.connection).to be_a(Net::FTP)
		expect(@ftp_connector.connection.closed?).to eq(false)
	end
  end

  describe '#download_file' do
	it "creates a local copy of a single file in the temp/downloads directory" do
		filename = 'test.txt'
		@ftp_connector.download_file(filename)
		expect(File.exist?(@download_location + filename)).to eq(true)
	end
  end

  describe '#download_folder' do
  	it 'creates a local copy of an entire folder' do
  		foldername = 'test'
  		@ftp_connector.download_folder(foldername)
  		expect(File.exist?(@download_location + foldername)).to eq(true)
		expect(File.directory?(@download_location + foldername)).to eq(true) 
  	end

  	it "creates a local copy of a folder's contents" do
		foldername = 'test'
  		remote_items = @ftp_connector.list_items
  		@ftp_connector.download_folder(foldername)
  		local_items = Dir.entries(@download_location + foldername)
		expect(local_items).to eq(remote_items)
  	end
  end

  describe '#upload_folder' do
  	pending 'it uploads an entire folder to the host'
  end

  describe '#upload_file' do
  	pending 'it uploads an entire file to the host'
  end

  describe '#close_connection' do
  	pending 'closes the FtpConnection'
  end

  describe '#is_folder?' do
  	it 'returns true if a remote item is a folder' do
  		filename = 'public_html'
  		expect(@ftp_connector.is_folder?(filename)).to eq(true)
  	end
  	it 'returns false if a remote item is a file' do
  		filename = 'test.txt'
  		expect(@ftp_connector.is_folder?(filename)).to eq(false)
  	end
  end

end
