class Sidekiq::EventBus::Adapters::Inline
  def push event, payload
    Sidekiq::EventBus.utils.handle_event(event, payload)
    SecureRandom.hex(8)
  end
end
