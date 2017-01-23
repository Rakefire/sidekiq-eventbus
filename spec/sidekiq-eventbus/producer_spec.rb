require 'spec_helper'

describe Sidekiq::EventBus::Producer do
  subject { Sidekiq::EventBus::Producer.new(topics: topic, adapter: adapter) }

  let(:topic)   { "test" }
  let(:adapter) { double(:adapter) }

  let(:event)   { "test.event" }
  let(:payload) { double(:payload) }

  it "publishes to an adapter" do
    expect(adapter).to receive(:push).with(topic, event, payload).and_return("123")

    subject.publish event, payload
  end
end