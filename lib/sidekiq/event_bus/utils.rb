class Sidekiq::EventBus::Utils
  attr_reader :config

  def initialize config
    @config = config
  end

  def consumers_for topic
    config.consumers[topic].map do |klass_name|
      klass_name.constantize.new
    end
  end

  def handle_event topic, event, payload
    consumers_for(topic).each do |consumer|
      consumer.consume(topic, event, payload)
    end
  end
end