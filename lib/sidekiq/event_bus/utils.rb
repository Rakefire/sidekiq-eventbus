class Sidekiq::EventBus::Utils
  def consumers
    Sidekiq::EventBus.config.consumers.map do |klass_name|
      klass_name.constantize.new
    end
  end

  def handle_event event, payload
    consumers.each do |consumer|
      consumer.consume(event, payload)
    end
  end

  def handle_error exception
    unless Sidekiq::EventBus.config.error_handler.nil?
      Sidekiq::EventBus.config.error_handler.call(exception)
    end
  end
end
