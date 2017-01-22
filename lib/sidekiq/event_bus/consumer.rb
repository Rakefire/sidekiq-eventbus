class Sidekiq::EventBus::Consumer
  # Register Consumer with the EventBus for a particular topic
  def self.topic *topics
    Array(topics).each do |topic|
      Sidekiq::EventBus.config.register_consumer(topic, self)
    end
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


  def consume topic, event, payload
    _payload = payload.merge('topic'.freeze => topic, 'event'.freeze => event).freeze

    self.class.handlers[event].each do |handler|
      begin
        if handler.is_a? Proc
          instance_exec( _payload.dup, &handler )
        else
          handler.call( _payload.dup )
        end
      rescue => e
        puts "OH NO!!!"
        puts e.inspect
        puts e.backtrace
      end
    end
  end
end