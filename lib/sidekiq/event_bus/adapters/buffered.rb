require 'concurrent'

class Sidekiq::EventBus::Adapters::Buffered
  def initialize adapter: Sidekiq::EventBus::Adapters::Default.new
    @adapter  = adapter
    @bufferes = Concurrent::Map.new
  end

  def push event, payload
    if is_buffered?
      event_buffer << [ event, payload ]
      nil
    else
      @adapter.push(event, payload)
    end
  end

  def buffered
    buffer!
    begin
      yield
      flush!
    ensure
      clear!
    end
  end

  def event_buffer
    @bufferes[buffer_key] ||= Array.new
  end

  def is_buffered?
    @bufferes.key?(buffer_key)
  end

  def buffer!
    @bufferes[buffer_key] ||= Array.new
  end

  def flush!
    event_buffer.map do |event, payload|
      @adapter.push(event, payload)
    end
  end

  def clear!
    @bufferes.delete(buffer_key)
  end

  def buffer_key
    Thread.current.object_id
  end
end
