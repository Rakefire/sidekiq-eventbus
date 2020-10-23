class Sidekiq::EventBus::Utils
  attr_reader :config

  def initialize config
    @config = config
  end

  def consumers
    config.consumers.map do |klass_name|
      klass_name.constantize.new
    end
  end

  def handle_event event, payload
    consumers.each do |consumer|
      consumer.consume(event, payload)
    end
  end

  def handle_error exception
    unless config.error_handler.nil?
      config.error_handler.call(exception)
    end
  end
end
