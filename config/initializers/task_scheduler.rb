require 'rufus-scheduler'

@queue_build_scheduler = Rufus::Scheduler.new

@queue_build_scheduler.cron('*/5 * * * *') do 
	build_backup_queue
end

@process_queue_scheduler = Rufus::Scheduler.new

@process_queue_scheduler.cron('*/6 * * * *') do
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
		@backups_queue.each do |backup|
			backup.backup
		end
	end
end