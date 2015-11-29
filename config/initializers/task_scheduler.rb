require 'rufus-scheduler'

@queue_build_scheduler = Rufus::Scheduler.new

@queue_build_scheduler.cron('0 0 * * *') do 
	build_backup_queue
end

@process_queue_scheduler = Rufus::Scheduler.new

@process_queue_scheduler.cron('10 0 * * *') do
	process_backup_queue
end

def build_backup_queue
	@backups = Backup.where(next_backup_date: Date.today)
	@backups_queue ||= []
	@backups.each do |backup|
		@backups_queue << backup
	end
end

def process_backup_queue
	if @backups_queue
		puts "About to process the following backups: #{@backups_queue}"
		puts "before starting queue"
		@backups_queue.each do |backup|
			puts backup
			puts "starting backup process from process_backup_queue"
			backup.backup
			@backups_queue.delete(backup)
		end
	end
end