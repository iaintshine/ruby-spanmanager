require "spec_helper"

RSpec.describe SpanManager::ThreadLocalManagedSpanSource do
  let(:span) { OpenTracing::Span.new }
  let(:active_span_source) { SpanManager::ThreadLocalManagedSpanSource.new }

  before { active_span_source.clear }

  describe :make_active do
    it 'returns instance of ActiveSpan::Span' do
      expect(active_span_source.make_active(span)).to be_instance_of SpanManager::ManagedSpan
    end
  end

  describe :active_span do
    context 'when an active span is on the stack' do
      it 'returns the active span' do
        active_span = active_span_source.make_active(span)

        expect(active_span_source.active_span).not_to be_nil
        expect(active_span_source.active_span).to eq(active_span)
      end
    end

    context 'when no active span on the stack' do
      it 'returns null' do
        expect(active_span_source.active_span).to be_nil
      end
    end
  end

  describe :deactivate do
    context 'when deactive is called' do
      it 'pops the last span out of the stack' do
        active_span = active_span_source.make_active(span)
        expect(active_span_source.active_span).not_to be_nil

        active_span.deactivate
        expect(active_span_source.active_span).to be_nil
      end
    end
  end
end
