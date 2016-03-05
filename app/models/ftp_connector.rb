class FtpConnector < Connector
	require 'net/ftp'
	validates :name, uniqueness: {scope: [:user_id, :username, :host]}
	attr_accessor :connection

	def download_and_close(path_to_item)
		connect_to_server
		path = download_item(path_to_item)
		@connection.close if @connection
		return path
	end

	def upload_and_close (path_to_item)
		connect_to_server
		upload_item(path_to_item)
		@connection.close if @connection
	end

	def list_items (path=nil)
		connect_to_server
		list = []
		# Do a bit of formatting to be able and use whitespaces in the path
		path.include?(" ") ? safe_path = path.gsub(" ", "\\ ") : safe_path = path
		puts safe_path
		@connection.ls(safe_path) do |line|
			line_items_hash = {}
			line_items = line.split(" ")

			# result from a ls is with the following format: 
			# drwxrwxr-x    2 user group       4096 Sep  7 13:59 cgi-bin
			line_items_hash[:item_name] = line_items[8..-1].join(" ")
			line_items_hash[:item_size] = line_items[4]
			if line_items[0].starts_with?("-")
				line_items_hash[:item_type] = "file"
			elsif line_items[0].starts_with?("l")
				line_items_hash[:item_type] = "link"
			else
				line_items_hash[:item_type] = "directory"
			end
			line_items_hash[:path_to_item] = path + line_items_hash[:item_name]
			line_items_hash[:path_to_item] += "/" if line_items_hash[:item_type] == "directory"
			list << line_items_hash
		end
		list.sort_by! { |item| [item[:item_type], item[:item_name]] }
		@connection.close
		return list
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

	def download_item(path_to_item, root_item = nil)
		unless root_item
			root_item = path_to_item.split("/").last
		end
		if is_remote_folder?(path_to_item)
			download_folder(path_to_item, root_item)
		else
			download_file(path_to_item, root_item)
		end
	end

	def download_file(path_to_file, root_item)
		@connection.getbinaryfile(path_to_file,nil) do |data|
			# Processors::BaseProcessor.download_obj(data, root_item)
			return data
		end
	end

	def download_folder(path_to_folder, root_item)
		items = @connection.nlst(path_to_folder)
		items.each do |item|
			download_item(path_to_folder + "/" + item, root_item + "/" + item) unless item == '.' || item == '..'
		end
	end

	def upload_item(path_to_item, is_first_item = true)
		item = File.basename(item)

		if File.directory?(item)
			upload_folder(item)
		else
			upload_file(item)
		end
	end

	def upload_file (filename, destination_path)
		@connection.put(filename)
	end


	def upload_folder (path_to_folder)
		@connection.mkdir(path_to_folder)
		@connection.chdir(path_to_folder)
		Dir.chdir(path_to_folder)
		Dir.foreach('.') do |item|
			unless File.basename(item) == '.' or File.basename(item) == '..'
			 	puts File.basename(item)
			 	upload_item(item)
			 end 
		end
		Dir.chdir('..')
		@connection.chdir('..')
	end

	def is_remote_folder?(path_to_item)
		begin
			@connection.chdir(path_to_item)
			@connection.chdir('..')
			return true
		rescue Net::FTPPermError
			return false 
		end
	end
end