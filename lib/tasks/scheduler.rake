namespace :scheduler do
	desc "This task builds a queue of all backups that should be processed today"
	task :build_backup_queue => :environment do
	  puts "Building queue..."
	  backups = Backup.where(next_backup_date: Date.today, queued: false)
	  backups.each do |backup|
			backup.delay(queue: 'backups').execute_transfer
		end
	  puts "done."
	end

	desc "This task creates a scheduler object"
	task :create_scheduler => :environment do
	end
end