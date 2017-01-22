class Sidekiq::EventBus::Adapters::Test
  attr_accessor :topics

  def initialize
    self.topics = Hash.new{ |hash, key| hash[key] = [] }
  end

  def push topic, event, payload
    id = SecureRandom.hex(8)
    self.topics[topic].push({
      topic:    topic,
      event:    event,
      payload:  payload,
      id:       id
    })

    id
  end

  def clear!
    self.topics.clear
  end
end