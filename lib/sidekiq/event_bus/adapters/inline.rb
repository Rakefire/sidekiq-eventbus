class Sidekiq::EventBus::Adapters::Inline
  def push topic, event, payload
    Sidekiq::EventBus.utils.handle_event(topic, event, payload)
    SecureRandom.hex(8)
  end
end