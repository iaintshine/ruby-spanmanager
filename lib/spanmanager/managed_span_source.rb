module SpanManager
  # ManagedSpanSource is an interface for a pluggable class that keeps track of the current active Span.
  # It must be used as a base class for a specific implementation.
  class ManagedSpanSource
    # Wrap and "make active" the span by encapsulating it in a new [SpanManager::ManagedSpan]
    #
    # The actived span becomes an implicit parent of a newly-created
    # span at [SpanManager::Tracer#start_span] time.
    #
    # @param span [OpenTracing::Span] the Span to wrap in [SpanManager::ManagedSpan].
    # @return [SpanManager::ManagedSpan] an active span that encapsulates the given span.
    def make_active(span)
    end

    # Retrieves the current active span.
    #
    # If there is an active span, it becomes an implicit parent of a newly-created
    # span at [SpanManager::Tracer#start_span] time.
    #
    # @return [SpanManager::ManagedSpan] returns the current active span, or null if none could be found.
    def active_span
    end

    # Unconditionally cleans up all managed spans.
    def clear
    end
  end
end
