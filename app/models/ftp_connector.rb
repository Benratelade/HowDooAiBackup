class FtpConnector < Connector
	require 'net/ftp'
	attr_accessor :connection

	def download_and_close(item)
		download_item(item)
		@connection.close if @connection
	end

	def upload_and_close (item)
		upload_item(item)
		@connection.close if @connection
	end

	def list_items
		connect_to_server
		@connection.nlst
	end

	private
	def connect_to_server
		puts "initiating connection to server"
		if @connection == nil || @connection.closed?
			@connection = Net::FTP.new(self.host, self.username, self.password)
			@connection.passive = true
			puts "Connected to server."
		end
	end

	def download_item(item, is_first_item = true)
		initiate_download if is_first_item
		connect_to_server
		if is_remote_folder?(item)
			download_folder(item)
		else
			download_file(item)
		end
		if Dir.getwd == @download_directory
			Dir.chdir('..')
			return @download_directory
		end
	end

	def upload_item(item, is_first_item = true)
		connect_to_server
		item = File.basename(item)

		if File.directory?(item)
			upload_folder(item)
		else
			upload_file(item)
		end
	end

	def download_file(filename)
		puts "Downloading file: #{filename}"
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

	def upload_file (filename)
		@connection.put(filename)
	end

	def upload_folder (foldername)
		@connection.mkdir(foldername)
		@connection.chdir(foldername)
		Dir.chdir(foldername)
		Dir.foreach('.') do |item|
			unless File.basename(item) == '.' or File.basename(item) == '..'
			 	puts File.basename(item)
			 	upload_item(item)
			 end 
		end
		Dir.chdir('..')
		@connection.chdir('..')
	end

	def is_remote_folder?(filename)
		begin
			@connection.chdir(filename)
			@connection.chdir('..')
			return true
		rescue Net::FTPPermError
			return false 
		end
	end
end