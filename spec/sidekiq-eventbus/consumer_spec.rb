require 'spec_helper'

describe Sidekiq::EventBus::Consumer do

  context '::topic' do
    subject { Class.new(Sidekiq::EventBus::Consumer) }
    it 'registers the class for a topic' do
      topic = "test-topic"
      config = double(:config)

      expect(Sidekiq::EventBus).to receive(:config) { config }
      expect(config).to receive(:register_consumer).with(topic, subject)

      subject.topic(topic)
    end
  end




  context '#consume' do
    let(:topic)   { "test" }
    let(:payload) { double(:payload) }

    let(:object_handler) { double(:obj_handler) }
    let(:raised_error)   { StandardError.new("error") }

    let(:utils) { double(:utils) }

    subject do
      _object = object_handler
      _error  = raised_error

      Class.new(Sidekiq::EventBus::Consumer) do
        on('object.event', _object)

        on('block.event') do |payload|
          payload.verify_block
        end

        on('raise.event') do |_|
          raise _error
        end
      end.new
    end


    before(:each) do
      allow(payload).to receive(:dup).and_return(payload)
      allow(payload).to receive(:freeze).and_return(payload)

      allow(Sidekiq::EventBus).to receive(:utils).and_return(utils)
      allow(utils).to receive(:handle_error) { |e| raise e }
    end



    context 'with a registered block for event' do
      let(:event)   { "block.event" }

      it "calls the block" do
        expect(payload).to receive(:merge).with({ 'event' => event, 'topic' => topic }).and_return(payload)
        expect(payload).to receive(:verify_block)

        subject.consume(topic, event, payload)
      end
    end


    context 'with a registered object for event' do
      let(:event)    { "object.event" }

      it "calls handler object" do
        expect(payload).to receive(:merge).with({ 'event' => event, 'topic' => topic }).and_return(payload)
        expect(object_handler).to receive(:call).with(payload)

        subject.consume(topic, event, payload)
      end
    end


    context 'with unknown event' do
      let(:event)   { "unknown.event" }

      it "doesn't do anything" do
        subject.consume(topic, event, payload)
      end
    end


    context 'error handling' do
      let(:event)   { "raise.event" }

      it "calls the error handler" do
        expect(payload).to receive(:merge).with({ 'event' => event, 'topic' => topic }).and_return(payload)
        expect(utils).to receive(:handle_error) do |e|
          expect(e).to be(raised_error)
        end

        subject.consume(topic, event, payload)
      end
    end
  end
end