class Sidekiq::EventBus::Consumer
  def self.register_consumer!
    Sidekiq::EventBus.config.register_consumer(self)
  end

  # Store handlers for this consumer
  def self.handlers
    @handlers ||= Hash.new { |hash, key| hash[key] = Array.new }
  end


  # Register a handler for a particular event
  def self.on event, handler=nil, &block
    if handler
      handlers[event] << handler
    else
      handlers[event] << block
    end
  end

  PAYLOAD_WITH_INDIFFERENT_ACCESS = defined?(ActiveSupport::HashWithIndifferentAccess)

  def consume event, payload
    if self.class.handlers.key? event
      _payload = payload.merge('event'.freeze => event).freeze

      if PAYLOAD_WITH_INDIFFERENT_ACCESS
        _payload = ActiveSupport::HashWithIndifferentAccess.new(_payload)
      end

      self.class.handlers[event].each do |handler|
        begin
          if handler.is_a? Proc
            instance_exec( _payload.dup, &handler )
          else
            handler.call( _payload.dup )
          end
        rescue => e
          Sidekiq::EventBus.utils.handle_error(e)
        end
      end
    end
  end
end
