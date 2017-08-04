module SpanManager
  # Convenience [OpenTracing::Tracer] that automates managing current span.
  #
  # It's a wrapper that forwards all calls to another [OpenTracing::Tracer] implementation.
  # Spans created with this tracer are automatically activated when started,
  # and deactivated when they finish.
  class Tracer < OpenTracing::Tracer
    extend Forwardable
    def_delegators :@tracer, :inject, :extract

    # @return [SpanManager::ManagedSpanSource] returns the active span source
    attr_reader :managed_span_source

    # @param tracer [OpenTracing::Tracer] the tracer to be wrapped.
    # @param active_span_source [SpanManager::ManagedSpanSource] the span source that keeps track of the current active span.
    def initialize(tracer, managed_span_source = ThreadLocalManagedSpanSource.new)
      @tracer = tracer
      @managed_span_source = managed_span_source
    end

    # Retrieves the current active span.
    #
    # @return [SpanManager::ManagedSpan] returns the current active span, or null if none could be found.
    def active_span
      managed_span_source.active_span
    end

    # Starts a new active span.
    #
    # @param operation_name [String] The operation name for the Span
    #
    # @param child_of [SpanContext, Span] SpanContext that acts as a parent to
    #        the newly-started Span. If default argument is used then the currently
    #        active span becomes an implicit parent of a newly-started span.
    #
    # @return [SpanManager::ManagedSpan] The newly-started active Span
    def start_span(operation_name, child_of: active_span, **args)
      span = @tracer.start_span(operation_name, child_of: child_of, **args)
      @managed_span_source.make_active(span)
    end
  end
end
