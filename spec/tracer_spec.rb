require "spec_helper"

RSpec.describe ActiveSpan::Tracer do
  let(:tracer) { OpenTracing::Tracer.new }
  let(:active_span_source) { ActiveSpan::ThreadLocalSpanSource.new }
  let(:active_span_tracer) { ActiveSpan::Tracer.new(tracer, active_span_source) }
  let(:operation_name) { "GET /users" }

  describe :start_span do
    def start_span
      active_span_tracer.start_span(operation_name)
    end

    it 'returns instance of ActiveSpan::Span' do
      active_span = start_span

      expect(active_span).to be_instance_of ActiveSpan::Span
    end

    it 'activates span' do
      expect(active_span_source).to receive(:make_active).and_call_original
      start_span
    end

    it 'returns active span' do
      active_span = start_span

      expect(active_span.active?).to be_truthy
    end

    describe :child_of do
      context 'default argument' do
        it 'sets parent span to current active span' do
          parent_span = start_span
          expect(tracer).to receive(:start_span).with(operation_name, child_of: parent_span).and_call_original
          start_span
        end
      end
    end
  end
end
