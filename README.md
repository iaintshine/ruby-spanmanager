[![Build Status](https://travis-ci.org/iaintshine/ruby-spanmanager.svg?branch=master)](https://travis-ci.org/iaintshine/ruby-spanmanager)

# SpanManager

Current span management for OpenTracing in Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'spanmanager'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install spanmanager


## ManagedSpanSource

`ManagedSpanSource` is a pluggable class that keeps track of the current active span. It relieves application developers from passing the current span around through their code. Application developers won't need to interact with a `ManagedSpanSource` reference directly, only implicitly through `SpanManager::Tracer`.

`ManagedSpanSource` provides the following methods:

1. `make_active(span)`  wraps and makes the given span active.
2. `active_span` returns the current active span.
3. `clear` unconditionally cleans up all manages spans.

## ThreadLocalManagedSpanSource

`ThreadLocalManagedSpanSource` is an actual implementation of `ManagedSpanSource`. Allows an application access and manipulation of the current span state on per thread basis. Maintains a stack-like thread-local storage of managed spans.

## ManagedSpan

`ManagedSpan` is a wrapper that forwards all calls to another `OpenTracing::Span` and layers on an in-process propagation capabilities.
The behaviour of `finish` method is changed. In addition to calling finish on wrapped span, if not yet deactivated, marks the end of active period for the span.

Provides the following additional methods:

1. `deactivate` marks the end of active period for the current span.
2. `active?` returns whether the span is active or not.
3. `wrapped` returns the wrapped span.

## SpanManager::Tracer

The library exposes a convenience `OpenTracing::Tracer` that automates managing current span.

It's a wrapper that forwards all calls to another `OpenTracing::Tracer` implementation e.g. Lightstep, Jaeger etc.
Spans which you will create through this tracer will be automatically activated when started, and
deactivated when they finish.

Provides the following additional methods:

1. `wrapped` returns the wrapped tracer.

## Usage

```ruby
require 'spanmanager'

OpenTracing.global_tracer = SpanManager::Tracer.new(Jaeger::Client.build, SpanManager::ThreadLocalManagedSpanSource.new)
```

To start a new active span, use the regular and known `start_span` method. If you use the default argument for `child_of` argument
then the currently active span becomes an implicit parent of a newly-started span. It means that you no longer have to 
pass the current span through the code.

When you finish the span, and if not yet deactivated, marks the end of the active period for the span. For `ThreadLocalManagedSpanSource`
it means it's removed from the top of the stack on a per-thread basis.

```ruby
rack_span = tracer.start_span("/GET users")
db_span = tracer.start_span("GetUsers") # rack_span became an implicit parent of db_span
db_span.finish
rack_span.finish
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/iaintshine/ruby-spanmanager. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Thanks

The development of the gem was heavily inspired by [Span manager implementation for Java](https://github.com/opentracing-contrib/java-spanmanager/).

Thank You for inspiration!
