require "spec_helper"

RSpec.describe SpanManager::ManagedSpanSource do
  describe 'Responds to' do
    [:make_active, :active_span, :clear].each do |method|
      it { should respond_to method }
    end
  end
end
