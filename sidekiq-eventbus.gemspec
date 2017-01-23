Gem::Specification.new do |s|
  s.name        = 'sidekiq-eventbus'
  s.version     = '0.0.3'
  s.date        = '2017-01-21'
  s.summary     = 'A simple Producer/Consumer event bus extension for Sidekiq'
  s.description = "A simple Producer/Consumer event bus extension for Sidekiq"
  s.authors     = ["Phil Monroe"]
  s.email       = 'phil@rakefire.io'
  s.files       = Dir["CHANGELOG.md", "MIT-LICENSE", "README.md", "lib/**/*"]
  s.homepage    = 'https://github.com/Rakefire/sidekiq-eventbus'
  s.license     = 'MIT'

  s.add_dependency 'sidekiq'
  s.add_development_dependency 'rspec'
end