class Backup < Transfer
	before_create :set_next_backup_date

	# TODO: Add validation: self.frequency must be in BACKUP_SCHEDULES

	BACKUP_SCHEDULES = [
		{frequency: 'daily', duration: 1.day},
		{frequency: 'weekly', duration: 1.week},
		{frequency: 'monthly', duration: 1.month}
	]

	attr_accessor :BACKUP_SCHEDULES
	
	# Allows scheduling a transfer. 
	def transfer
		attributes = super
		self.last_backup_date = Date.today
		set_next_backup_date
		self.save
		log_transfer(attributes)
	end

	def set_next_backup_date
		self.next_backup_date = Date.today + BACKUP_SCHEDULES[self.frequency]
	end
end