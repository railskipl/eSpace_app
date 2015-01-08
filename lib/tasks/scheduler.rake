task :send_reminders => :environment do
  
    Booking.my_cron
 
end