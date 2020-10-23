class Sidekiq::EventBus::Adapters::Log
  def push event, payload
    id = SecureRandom.hex(8)
    puts "event=#{event}  id=#{id}  payload=#{payload.to_json}"
    id
  end
end
