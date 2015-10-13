class FtpConnector < Connector
	require 'net/ftp'
	after_initialize :connect_to_server, :set_download_location
	attr_accessor :connection

	def connect_to_server
		@connection = Net::FTP.new(self.host, self.username, self.password)
	end

	def download_item(item)
		if is_folder?(item)
			download_folder(item)
		else
			download_file(item)
		end
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
			download_item(item) unless item == '.' || item == '..'
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

	private
	def set_download_location
		Dir.chdir('temp/downloads/')
	end
end
