class Sidekiq::EventBus::Adapters::Default
  def push topic, event, payload
    Sidekiq::Client.push({
      'class' => Sidekiq::EventBus::EventWorker,
      'args'  => [ event, payload ],
      'queue' => topic,
    })
  end
end