class Sidekiq::EventBus::Adapters::Test
  attr_accessor :events

  def initialize
    self.events = []
  end

  def push event, payload
    id = SecureRandom.hex(8)
    self.events.push({
      event:    event,
      payload:  payload,
      id:       id
    })

    id
  end

  def clear!
    self.events.clear
  end
end
