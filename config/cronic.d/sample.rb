# Sample job definitions
#
# All *.rb files found in this directory will be instance_eval'd in the context
# of a Rufus::Scheduler instance, see
# https://github.com/jmettraux/rufus-scheduler for more methods and options.
#
# Jobs will be run with the full Rails application loaded. Consider placing
# your more complex job logic into separate worker classes to keep job
# definitions readable.


# output the current time every 5 minutes
every 1.minutes do
  #PayementTransfersController.automatic_transfer_money
  @test = PayementTransfersController.poster_confirmation_reminder
 
end


