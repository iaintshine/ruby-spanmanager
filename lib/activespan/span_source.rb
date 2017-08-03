module ActiveSpan
  # SpanSource is an interface for a pluggable class that keeps track of the current active Span.
  # It must be used as a base class for a specific implementation.
  class SpanSource
    # Wrap and "make active" the span by encapsulating it in a new [ActiveSpan::Span]
    #
    # The actived span becomes an implicit parent of a newly-created
    # span at [ActiveSpan::Tracer#start_span] time.
    #
    # @param span [OpenTracing::Span] the Span to wrap in [ActiveSpan::Span].
    # @return [ActiveSpan::Span] an [ActiveSpan::Span] that encapsulates the given span.
    def make_active(span)
    end

    # Retrieves the current active span.
    #
    # If there is an active span, it becomes an implicit parent of a newly-created
    # span at [ActiveSpan::Tracer#start_span] time.
    #
    # @return [ActiveSpan::Span] returns the current active span, or null if none could be found.
    def active_span
    end
  end
end
