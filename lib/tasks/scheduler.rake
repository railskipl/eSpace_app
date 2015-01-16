task :send_reminders => :environment do
  if Time.now.hour % 1 == 0
    PaymentTransfer.my_cron
  end
end