require 'spec_helper'

describe Sidekiq::EventBus::Consumer do
  context '.register_consumer!' do
    it 'does not register the consumer until register_consumer! is called' do
      config = Sidekiq::EventBus::Configuration.new
      allow(Sidekiq::EventBus).to receive(:config) { config }

      expect(config.consumers).to be_empty

      stub_const('TestConsumer', Class.new(Sidekiq::EventBus::Consumer))
      expect(config.consumers).to be_empty

      TestConsumer.register_consumer!
      expect(config.consumers).to include('TestConsumer')
    end
  end

  context '#consume' do
    after(:each) do
      Sidekiq::EventBus.config.consumers.clear
    end

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
        expect(payload).to receive(:merge).with({ 'event' => event }).and_return(payload)
        expect(payload).to receive(:verify_block)

        subject.consume(event, payload)
      end
    end


    context 'with a registered object for event' do
      let(:event)    { "object.event" }

      it "calls handler object" do
        expect(payload).to receive(:merge).with({ 'event' => event }).and_return(payload)
        expect(object_handler).to receive(:call).with(payload)

        subject.consume(event, payload)
      end
    end


    context 'with unknown event' do
      let(:event)   { "unknown.event" }

      it "doesn't do anything" do
        subject.consume(event, payload)
      end
    end


    context 'error handling' do
      let(:event)   { "raise.event" }

      it "calls the error handler" do
        expect(payload).to receive(:merge).with({ 'event' => event }).and_return(payload)
        expect(utils).to receive(:handle_error) do |e|
          expect(e).to be(raised_error)
        end

        subject.consume(event, payload)
      end
    end
  end
end
