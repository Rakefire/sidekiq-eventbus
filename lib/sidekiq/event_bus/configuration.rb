class Sidekiq::EventBus::Configuration
  attr_accessor :adapter, :consumers, :sidekiq_worker_options
  def initialize
    self.adapter                = Sidekiq::EventBus::Adapters::Default.new
    self.consumers              = Hash.new { |hash, key| hash[key] = Set.new }
    self.sidekiq_worker_options = { retry: 0, dead: true }
  end

  def register_consumer topic, klass
    klass = klass.name unless klass.is_a?(String)
    consumers[topic] << klass
  end
end