module ActiveSpan
  # The [ActiveSpan::Span] inherits all of the OpenTracing funcionality and layers on
  # in-process propagation capabilities.
  class Span < OpenTracing::Span
    extend Forwardable

    def_delegators :@span, :context, :operation_name=, :set_tag, :set_baggage_item, :get_baggage_item, :log, :finish

    # Initializes a new active span. It's SpanSource responsibility to activate the span.
    #
    # @param span [OpenTracing::Span] the span to wrap
    # @param deactivate [Proc] the current span deactivation supplier. The block must return instance of [ActiveSpan::Span]
    def initialize(span, deactivate)
      @span = span
      @deactivate = deactivate.respond_to?(:call) ? deactivate : nil
      @active = true
    end

    # @return [Boolean] whether the span is active or not
    def active?
      @active
    end

    # Mark the end of active period for the current span in this asynchronus executor and/or thread.
    # It's safe to call the method multiple times.
    def deactivate
      if @active && @deactivate
        deactivated_span = @deactivate.call
        warn "ActiveSpan::SpanSource inconsistency found during deactivation" unless deactivated_span == self
        @active = false
      end
    end

    # Finishes the current span, and if not yet deactivated marks the end of the active period for the span.
    # @param end_time [Time] custom end time, if not now
    def finish(end_time: Time.now)
      deactivate
      @span.finish(end_time: end_time)
    end
  end
end
