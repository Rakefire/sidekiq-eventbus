class Sidekiq::EventBus::Producer
  attr_reader :topics, :adapter

  def initialize topics:, adapter: Sidekiq::EventBus.config.adapter
    @topics  = Array(topics)
    @adapter = adapter
  end

  def publish event, payload
    topics.map do |topic|
      adapter.push topic, event, payload
    end
  end
end