task :send_reminders => :environment do
  if Time.now.min % 10 == 0
    Booking.my_cron
  end
end