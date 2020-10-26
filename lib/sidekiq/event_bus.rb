require 'sidekiq'

module Sidekiq
  module EventBus
    autoload :Configuration,    'sidekiq/event_bus/configuration'
    autoload :Utils,            'sidekiq/event_bus/utils'

    autoload :Consumer,         'sidekiq/event_bus/consumer'
    autoload :Producer,         'sidekiq/event_bus/producer'

    autoload :EventWorker,      'sidekiq/event_bus/event_worker'

    module Adapters
      autoload :Default,        'sidekiq/event_bus/adapters/default'
      autoload :Buffered,       'sidekiq/event_bus/adapters/buffered'
      autoload :Inline,         'sidekiq/event_bus/adapters/inline'
      autoload :Test,           'sidekiq/event_bus/adapters/test'
      autoload :Log,            'sidekiq/event_bus/adapters/log'
    end

    def self.config
      @config ||= Configuration.new
    end

    def self.utils
      @utils ||= Utils.new
    end

    def self.configure
      yield(config) if block_given?
    end
  end
end
