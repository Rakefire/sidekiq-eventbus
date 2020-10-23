class Sidekiq::EventBus::Adapters::Default
  def push event, payload
    Sidekiq::Client.push({
      'class' => Sidekiq::EventBus::EventWorker,
      'args'  => [ event, payload ]
    })
  end
end
