module ActiveSpan
  # ThreadLocalSpanSource allows an application access and manipulation of the current span state on per thread basis.
  class ThreadLocalSpanSource < SpanSource
    def make_active(span)
      active_span = Span.new(span, method(:pop))
      push(active_span)
      active_span
    end

    def active_span
      local_stack.last
    end

    def clear
      local_stack.clear
    end

  private
    # Adds the given span to the stack
    #
    # @param span [Span] The span to be pushed
    def push(span)
      local_stack << span
    end

    # Removes a span from the stack
    #
    # @return [Span] returns and removes the current span from the top of the stack
    def pop
      local_stack.pop
    end

    # @return [Array] return a per thread basis stack of spans.
    def local_stack
      Thread.current[:__active_span__] ||= []
    end
  end
end
