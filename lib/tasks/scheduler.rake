namespace :scheduler do
	desc "This task builds a queue of all backups that should be processed today"
	task :build_backup_queue => :environment do
	  puts "Building queue..."
	  backups = Backup.where(next_backup_date: Date.today)
	  backups.each do |backup|
			Processors::TransferProcessor.delay(queue: 'backups').process_transfer(backup)
		end
	  puts "done."
	end

end