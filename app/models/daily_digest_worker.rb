class DailyDigestWorker do
  include Sidekiq::Worker
  include Sidekiq::Schedule

  recurrence { daily(1) }

  def perform
    User.send_daily_digest
  end
end
