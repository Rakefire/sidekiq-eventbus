class Sidekiq::EventBus::TopicMiddleware
  def initialize(options=nil)
  end

  def call(worker, msg, queue)
    worker.topic = queue if worker.respond_to?("topic=")
    yield
  end
end