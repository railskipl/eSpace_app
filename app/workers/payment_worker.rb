class PaymentWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  def perform
    PaymentTransfer.my_cron
  end
end
