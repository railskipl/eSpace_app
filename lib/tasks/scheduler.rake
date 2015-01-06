task :send_reminders => :environment do
  if Time.now.hour % 6 == 0
    Booking.my_cron
  end
end