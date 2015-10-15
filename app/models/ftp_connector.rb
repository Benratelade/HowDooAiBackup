class FtpConnector < Connector
	require 'net/ftp'
	after_initialize :connect_to_server
	attr_accessor :connection

	def connect_to_server
		@connection = Net::FTP.new(self.host, self.username, self.password)
		@connection.passive = true
	end

	def download_item(item, is_first_item = true)
		initiate_download if is_first_item
		connect_to_server if @connection.closed? 
		if is_folder?(item)
			download_folder(item)
		else
			download_file(item)
		end
		Dir.chdir('..') if Dir.getwd == @download_directory
	end

	def download_file(filename)
		@connection.getbinaryfile(filename,filename)
	end

	def download_folder(foldername)
		Dir.mkdir(foldername)
		Dir.chdir(foldername)
		puts 'Current local directory: ' + Dir.getwd
		@connection.chdir(foldername)
		items = @connection.nlst
		items.each do |item|
			download_item(item, false) unless item == '.' || item == '..'
		end
		@connection.chdir('..')
		Dir.chdir('..')
	end

	def is_folder?(filename)
		begin
			@connection.chdir(filename)
			@connection.chdir('..')
			return true
		rescue Net::FTPPermError
			return false 
		end
	end
end
