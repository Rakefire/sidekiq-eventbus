require 'spec_helper'

describe Sidekiq::EventBus::Adapters do
  let(:topic)   { double(:topic) }
  let(:event)   { double(:event) }
  let(:payload) { double(:payload) }

  describe Sidekiq::EventBus::Adapters::Default do
    it 'pushes to Sidekiq' do
      expect(Sidekiq::Client).to receive(:push).with({
        'class' => Sidekiq::EventBus::EventWorker,
        'args'  => [ event, payload ],
        'queue' => topic
      })

      subject.push(topic, event, payload)
    end
  end

  describe Sidekiq::EventBus::Adapters::Inline do
    it 'runs inline' do
      expect(Sidekiq::EventBus.utils).to receive(:handle_event).with(topic, event, payload)
      subject.push(topic, event, payload)
    end
  end

  describe Sidekiq::EventBus::Adapters::Test do
    it 'saves events for later inspection' do
      subject.push(topic, event, payload)
      expect(subject.topics[topic]).to include(topic: topic, event: event, payload: payload, id: kind_of(String))
    end
  end
end