class Sidekiq::EventBus::EventWorker
  include Sidekiq::Worker

  attr_accessor :topic

  sidekiq_options Sidekiq::EventBus.config.sidekiq_worker_options

  def perform(event, payload)
    Sidekiq::EventBus.utils.handle_event(topic, event, payload)
  end
end