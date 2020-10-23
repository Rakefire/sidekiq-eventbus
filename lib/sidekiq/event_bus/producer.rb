class Sidekiq::EventBus::Producer
  attr_reader :adapter

  def initialize adapter: Sidekiq::EventBus.config.adapter
    @adapter = adapter
  end

  def publish event, payload
    adapter.push event, payload
  end
end
