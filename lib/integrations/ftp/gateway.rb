class Integrations::FTP::Gateway < Integrations::StorageApi
	require 'net/ftp'
	require 'stringio'

	attr_accessor :connection, :upload_proc

	def init(connector)
		if @connection == nil || @connection.closed?
			@connection = Net::FTP.new(connector.host, connector.username, connector.password)
			@connection.passive = true
			puts "Connected to server #{connector.host}."
		end
	end

	# The root_item param is used to define a starting point
	# for the path of nested folders. 
	def get_item(path_to_item, upload_to_destination = nil, root_item = nil)
		root_item = path_to_item.split.last unless root_item
		if is_remote_folder?(path_to_item.to_s)
			get_folder(path_to_item.to_s, upload_to_destination, root_item)
		else
			get_file(path_to_item.to_s, root_item) do |data, root_item|
				if upload_to_destination
					upload_to_destination.call(data, root_item)
				else
					yield data, path_to_item, root_item 
				end
			end
		end
	end

	def get_folder(path_to_folder, upload_to_destination, root_item)
		items = @connection.nlst(path_to_folder)
		items.each do |item|
			get_item(path_to_folder + "/" + item, upload_to_destination, root_item + "/" + item) unless item == '.' || item == '..'
		end
	end
 
	def get_file (path_to_file, root_item)
		@connection.getbinaryfile(path_to_file,nil) do |data|
			yield data, root_item if block_given?
		end
	end

	# def upload_item(path_to_item, is_first_item = true)
	# 	item = File.basename(item)

	# 	if File.directory?(item)
	# 		upload_folder(item)
	# 	else
	# 		upload_file(item)
	# 	end
	# end

	# def upload_folder (path_to_folder)
	# 	@connection.mkdir(path_to_folder)
	# 	@connection.chdir(path_to_folder)
	# 	Dir.chdir(path_to_folder)
	# 	Dir.foreach('.') do |item|
	# 		unless File.basename(item) == '.' or File.basename(item) == '..'
	# 		 	puts File.basename(item)
	# 		 	upload_item(item)
	# 		 end 
	# 	end
	# 	Dir.chdir('..')
	# 	@connection.chdir('..')
	# end

	def upload_file(data, filename, destination_path)
		@connection.putdata(data, destination_path + filename)
	end

	# root_item should already be a Pathname
	def get_upload_proc(path_in_remote)
		@upload_proc = lambda do |data, root_item|
			# Creating all the folders that are in the path
			path_in_remote.split[0].descend do |folder|
				@connection.mkdir(folder.to_s)
			end
			@connection.putdata(data, root_item)
		end
		return @upload_proc
	end

	def list_items (path=nil)
		list = []
		# Do a bit of formatting to be able and use whitespaces in the path
		path.include?(" ") ? safe_path = path.gsub(" ", "\\ ") : safe_path = path
		puts safe_path
		@connection.ls(safe_path) do |line|
			line_items_hash = {}
			line_items = line.split(" ")

			# result from a ls is with the following format: 
			# drwxrwxr-x    2 user group       4096 Sep  7 13:59 cgi-bin
			line_items_hash[:source_path] = line_items[8..-1].join(" ")
			line_items_hash[:item_size] = line_items[4]
			if line_items[0].starts_with?("-")
				line_items_hash[:item_type] = "file"
			elsif line_items[0].starts_with?("l")
				line_items_hash[:item_type] = "link"
			else
				line_items_hash[:item_type] = "directory"
			end
			line_items_hash[:path_to_item] = path + line_items_hash[:source_path]
			line_items_hash[:path_to_item] += "/" if line_items_hash[:item_type] == "directory"
			list << line_items_hash
		end
		list.sort_by! { |item| [item[:item_type], item[:source_path]] }
		@connection.close
		return list
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



	# Extending the Net::FTP class so that we can upload 
	# a stream without having a file on disk
	class Net::FTP
 		def putdata(data, remotefile = File.basename(localfile), blocksize = DEFAULT_BLOCKSIZE, &block) # :yield: data
		 	if @resume
		    	begin
		      		rest_offset = size(remotefile)
				rescue Net::FTPPermError
		  			rest_offset = nil
				end
		 	else
    			rest_offset = nil
			end
			f = StringIO.new(data)
			if rest_offset
  				storbinary("APPE " + remotefile, f, blocksize, rest_offset, &block)
			else
  				storbinary("STOR " + remotefile, f, blocksize, rest_offset, &block)
			end
		end
	end
end