require "spec_helper"

RSpec.describe SpanManager::ManagedSpan do
  let(:span) { OpenTracing::Span.new }
  let(:deactivate) { -> { active_span } }
  let(:active_span)  { SpanManager::ManagedSpan.new(span, deactivate) }

  describe :initialize do
    it 'creates active span' do
      expect(active_span.active?).to be_truthy
    end
  end

  describe :wrapped do
    it 'returns the wrapped span' do
      expect(active_span.wrapped).to eq(span)
    end
  end

  describe :deactivate do
    it 'calls deactivate supplier' do
      expect(deactivate).to receive(:call).and_call_original
      active_span.deactivate
    end

    it 'sets active to false' do
      active_span.deactivate
      expect(active_span.active?).to be_falsey
    end

    it 'deactivates the span only once' do
      expect(deactivate).to receive(:call).once.and_call_original
      active_span.deactivate
      active_span.deactivate
    end
  end

  describe :finish do
    it 'calls finish on wrapped span' do
      expect(span).to receive(:finish).once.and_call_original
      active_span.finish
    end

    it 'auto deactivates the span' do
      expect(deactivate).to receive(:call).once.and_call_original
      active_span.finish
    end
  end
end
