/// Describes the relationship between a [Span], its parents, and its
/// children in a trace.
enum SpanKind {
  /// The span represents an internal operation that does not involve
  /// remote communication.
  internal,

  /// The span represents the server side of a synchronous RPC.
  server,

  /// The span represents the client side of a synchronous RPC.
  client,

  /// The span represents the producer side of an asynchronous message
  /// exchange.
  producer,

  /// The span represents the consumer side of an asynchronous message
  /// exchange.
  consumer,
}

/// The status of a completed [Span].
///
/// Set via [Span.setStatus] to indicate whether the operation succeeded or
/// failed.
enum StatusCode {
  /// The default status — the span completed without an explicit status.
  unset,

  /// The span completed successfully.
  ok,

  /// The span completed with an error.
  error,
}
