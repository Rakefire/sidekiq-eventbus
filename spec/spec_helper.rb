require 'bundler/setup'
Bundler.require

$:.unshift File.expand_path('../../lib')
require 'sidekiq-eventbus'