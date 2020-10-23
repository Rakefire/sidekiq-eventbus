class Sidekiq::EventBus::EventWorker
  include Sidekiq::Worker

  sidekiq_options Sidekiq::EventBus.config.sidekiq_worker_options

  def perform(event, payload)
    Sidekiq::EventBus.utils.handle_event(event, payload)
  end
end
