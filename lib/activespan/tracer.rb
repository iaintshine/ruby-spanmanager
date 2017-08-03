module ActiveSpan
  # Convenience [OpenTracing::Tracer] that automates managing current span.
  #
  # It's a wrapper that forwards all calls to another [OpenTracing::Tracer] implementation.
  # Spans created with this tracer are automatically activated when started,
  # and deactivated when they finish.
  class Tracer < OpenTracing::Tracer
    CURRENT_ACTIVE_SPAN = Span.new(nil, nil).freeze

    extend Forwardable
    def_delegators :@tracer, :inject, :extract

    # @return [ActiveSpan::SpanSource] returns the active span source
    attr_reader :active_span_source

    # @param tracer [OpenTracing::Tracer] the tracer to be wrapped.
    # @param active_span_source [ActiveSpan::SpanSource] the span source that keeps track of the current active span.
    def initialize(tracer, active_span_source)
      @tracer = tracer
      @active_span_source = active_span_source
    end

    # Retrieves the current active span.
    #
    # @return [ActiveSpan::Span] returns the current active span, or null if none could be found.
    def active_span
      active_span_source.active_span
    end

    # Starts a new active span.
    #
    # @param operation_name [String] The operation name for the Span
    #
    # @param child_of [SpanContext, Span] SpanContext that acts as a parent to
    #        the newly-started Span. If default argument is used then the currently
    #        active span becomes an implicit parent of a newly-started span.
    #
    # @return [ActiveSpan::Span] The newly-started active Span
    def start_span(operation_name, child_of: CURRENT_ACTIVE_SPAN, **args)
      parent_span = child_of == CURRENT_ACTIVE_SPAN ? active_span_source.active_span : child_of
      span = @tracer.start_span(operation_name, child_of: parent_span, **args)
      @active_span_source.make_active(span)
    end
  end
end
