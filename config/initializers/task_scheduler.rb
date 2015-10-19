require 'rufus-scheduler'

queue_build_scheduler = Rufus::Scheduler.new

queue_build_scheduler.cron('') do 
	build_queue
end

process_queue_scheduler = Rufus::Scheduler.new

process_queue_scheduler.cron('') do
	process_queue
end