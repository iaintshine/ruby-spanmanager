require "spec_helper"

RSpec.describe ActiveSpan::SpanSource do
  describe 'Responds to' do
    [:make_active, :active_span].each do |method|
      it { should respond_to method }
    end
  end
end
