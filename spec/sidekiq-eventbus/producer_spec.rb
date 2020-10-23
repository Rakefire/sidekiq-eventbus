require 'spec_helper'

describe Sidekiq::EventBus::Producer do
  subject { Sidekiq::EventBus::Producer.new(adapter: adapter) }

  let(:adapter) { double(:adapter) }

  let(:event)   { "test.event" }
  let(:payload) { double(:payload) }

  it "publishes to an adapter" do
    expect(adapter).to receive(:push).with(event, payload).and_return("123")

    subject.publish event, payload
  end
end
