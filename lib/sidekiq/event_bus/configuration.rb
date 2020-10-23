class Sidekiq::EventBus::Configuration
  attr_accessor :adapter, :consumers, :sidekiq_worker_options, :error_handler

  def initialize
    self.adapter                = Sidekiq::EventBus::Adapters::Default.new
    self.consumers              = Set.new
    self.sidekiq_worker_options = { retry: 0, dead: true }
  end

  def register_consumer klass
    klass = klass.name unless klass.is_a?(String)
    consumers << klass
  end
end
