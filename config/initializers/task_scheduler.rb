require 'rufus-scheduler'

@queue_build_scheduler = Rufus::Scheduler.new

@queue_build_scheduler.cron('/2 * * * *') do 
	build_backup_queue
end

@process_queue_scheduler = Rufus::Scheduler.new

@process_queue_scheduler.cron('/3 * * * *') do
	process_backup_queue
end

def build_backup_queue
	puts "Building backups queue"
	backups = Backup.where(next_backup_date: Date.today, queued: false)
	@backups_queue ||= []
	backups.each do |backup|
		backup.queued == true
		@backups_queue << backup
	end
	Backup.transaction do 
		@backups_queue.each do |backup|
			backup.save
		end
	end
end

def process_backup_queue
	if @backups_queue
		puts "About to process the following backups: #{@backups_queue}"
		puts "before starting queue"
		@backups_queue.each do |backup|
			puts backup
			puts "starting backup process from process_backup_queue"
			backup.execute_transfer
			@backups_queue.delete(backup)
			backup.queued = false
			backup.save
		end
	end
end