require File.expand_path("../lib/sidekiq/event_bus/VERSION", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'sidekiq-eventbus'
  s.version     = Sidekiq::EventBus::VERSION
  s.summary     = 'Producer/Consumer event bus via Sidekiq'
  s.description = "A simple asynchronous Producer/Consumer event bus extension for Sidekiq"
  s.authors     = ["Phil Monroe"]
  s.email       = 'phil@rakefire.io'
  s.files       = Dir["CHANGELOG.md", "MIT-LICENSE", "README.md", "lib/**/*"]
  s.homepage    = 'https://github.com/Rakefire/sidekiq-eventbus'
  s.license     = 'MIT'

  s.add_dependency('concurrent-ruby', ['>= 1.0.0', '< 2.0'])
  s.add_dependency('sidekiq', '>= 4.0.0', '< 8.0')
  s.add_development_dependency('rspec', ['>= 3.5.0', '< 4.0'])
end
