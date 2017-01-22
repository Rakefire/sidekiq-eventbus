class Sidekiq::EventBus::Adapters::Log
  def push topic, event, payload
    id = SecureRandom.hex(8)
    puts "topic=#{topic}  event=#{event}  id=#{id}  payload=#{payload.to_json}"
    id
  end
end