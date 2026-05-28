# PurpleOTel API

[![Pub Version](https://img.shields.io/pub/v/purple_otel_api.svg)](https://pub.dev/packages/purple_otel_api)
[![License: AGPL-3.0](https://img.shields.io/badge/license-AGPL--3.0-blue.svg)](LICENSE)
[![Dart](https://img.shields.io/badge/dart-%3E%3D3.2.0-blue.svg)](https://dart.dev)
[![Tests](https://img.shields.io/badge/tests-22%20passed-success.svg)](https://github.com/Kilo-Org/kilocode)

**OpenTelemetry API for Dart** — interfaces, no-op implementations, and semantic conventions. Zero external dependencies.

---

## Features

- **Zero dependencies** — only `meta`; nothing else pulled into your dependency graph
- **Full OTel signal coverage** — Traces, Logs, Metrics, with Context, Baggage, and Resource
- **Sealed `AttributeValue`** — exhaustively matched six-variant sealed class (string, int, double, bool, list, bytes)
- **Immutable `Context`** — typed `ContextKey<T>` with pull-based propagation via injectable `ContextStorage`
- **Generic `SignalProvider<T>` and `SignalExporter<T>`** — one pattern, three signals; no duplicate interface defs
- **22 instrument types** — Counter, Histogram, UpDownCounter, Gauge, + all 6 observable variants
- **24 severity levels** — trace → fatal with full OTel severity number mapping
- **No-op implementations** — safe silent defaults when no SDK is configured; never throws NPE
- **OpenTelemetry 1.29+ compliant** — SpanLimits, MetricCardinalityLimits, View API, IdGenerator, Sampler, SpanProcessor, LogRecordProcessor
- **Immutable design** — all data classes are `const`-constructible and value-equal

---

## Installation

```yaml
# pubspec.yaml
dependencies:
  purple_otel_api: ^0.1.0
```

```bash
dart pub get
```

## Quick Start

```dart
import 'package:purple_otel_api/purple_otel_api.dart';

void main() {
  // No-op providers give you safe defaults — no SDK required
  final tracer = const NoopTracerProvider().get('my-component');
  final span = tracer.startSpan('example-operation');
  span.setAttribute('key', AttributeValue.string('value'));
  span.end(); // silently discarded

  // Swap in purple_otel_sdk for real telemetry
  // final tracer = OTelSdk.instance.tracerProvider.get('my-component');
}
```

When you're ready for real exports, replace the no-op providers with `purple_otel_sdk`:

```dart
import 'package:purple_otel_sdk/purple_otel_sdk.dart';

void main() async {
  final sdk = OTelSdk(
    resource: Resource(const Attributes.empty()),
    spanExporter: OtlpHttpSpanExporter(endpoint: 'http://localhost:4318/v1/traces'),
  );
  await sdk.start();

  final tracer = sdk.tracerProvider.get('auth-service', version: '1.2.0');
  // All spans now flow to your collector
}
```

---

## API Reference

### Traces

The tracing API models the full OTel trace data path — from `TracerProvider` through `SpanProcessor` to export.

| Type | Role |
|------|------|
| `TracerProvider` | Creates named `Tracer` instances |
| `Tracer` | Starts spans |
| `Span` | Records attributes, events, links, exceptions, and status |
| `SpanContext` | Immutable trace identity: `TraceId`, `SpanId`, `TraceFlags`, `TraceState` |
| `SpanKind` | `internal`, `server`, `client`, `producer`, `consumer` |
| `SpanStatus` | `unset`, `ok`, or `error` with description |
| `SpanLink` | Causal reference to another `SpanContext` with attributes |
| `SpanEvent` | Time-stamped named event inside a span |
| `Sampler` | Sampling decision interface: `drop`, `recordOnly`, `recordAndSample` |
| `SamplingResult` | Result from a `Sampler.shouldSample()` call |
| `SpanProcessor` | Hook for `onStart` / `onEnd` + `forceFlush` / `shutdown` |
| `IdGenerator` | Pluggable `TraceId` / `SpanId` generation |
| `SpanLimits` | Configurable attribute/event/link cardinality caps |
| `SpanExporter` | Typedef for `SignalExporter<Span>` |
| `TraceId` / `SpanId` / `TraceFlags` | OTel wire-format identifiers (16-byte / 8-byte / 1-byte) |
| `TraceState` | W3C tracestate header parser and serializer |

```dart
final tracer = tracerProvider.get('api-gateway', version: '3.1.0');

final span = tracer.startSpan(
  'POST /orders',
  kind: SpanKind.server,
  attributes: Attributes.of({
    'http.method': AttributeValue.string('POST'),
    'http.url': AttributeValue.string('/orders'),
    'http.status_code': AttributeValue.int(201),
  }),
  links: [SpanLink(spanContext: upstreamContext)],
);

span.addEvent('order.created', attributes: Attributes.of({
  'order.id': AttributeValue.string('ord-9913'),
}));

span.recordException(
  FormatException('invalid payload'),
  stackTrace: StackTrace.current,
);

span.setStatus(SpanStatus.ok);
span.end();
```

### Logs

The logging API mirrors the OTel log data model with full trace context attachment.

| Type | Role |
|------|------|
| `LoggerProvider` | Creates named `Logger` instances |
| `Logger` | Emits `LogRecord` instances |
| `LogRecord` | Immutable log event: timestamp, severity, body, attributes, trace context |
| `Severity` | 24-level enum from `trace(1)` to `fatal(24)` |
| `LogRecordProcessor` | Hook for `onEmit` + `forceFlush` / `shutdown` |
| `LogRecordExporter` | Typedef for `SignalExporter<LogRecord>` |

```dart
final logger = loggerProvider.get('payment-service');

// Severity carries the OTel severity number
logger.emit(LogRecord(
  timestamp: DateTime.now(),
  observedTimestamp: DateTime.now(),
  severityNumber: Severity.warn,
  severityText: 'WARN',
  body: AttributeValue.string('Payment gateway latency exceeded threshold'),
  attributes: Attributes.of({
    'gateway': AttributeValue.string('stripe'),
    'latency_ms': AttributeValue.double(1500.0),
    'order.id': AttributeValue.string('ord-9913'),
  }),
  traceId: currentSpan.spanContext.traceId,
  spanId: currentSpan.spanContext.spanId,
  traceFlags: currentSpan.spanContext.traceFlags,
));

// Convenient severity presets
// Severity.trace, .debug, .info, .warn, .error, .fatal
// Plus 4 sub-levels each: .info2, .info3, .info4, etc.
```

### Metrics

The metrics API supports synchronous and asynchronous instruments with cardinality controls.

| Type | Role |
|------|------|
| `MeterProvider` | Creates named `Meter` instances |
| `Meter` | Creates instruments — synchronous and observable |
| `Counter<T>` | Monotonic counter (`add`) |
| `UpDownCounter<T>` | Non-monotonic counter (`add`) |
| `DoubleHistogram` | Distribution recorder (`record`) |
| `LongHistogram` | Integer distribution recorder (`record`) |
| `ObservableDoubleGauge` | Callback-driven gauge (`observe`) |
| `ObservableLongGauge` | Integer variant |
| `ObservableDoubleCounter` | Observable monotonic counter |
| `ObservableLongCounter` | Integer variant |
| `ObservableDoubleUpDownCounter` | Observable non-monotonic counter |
| `ObservableLongUpDownCounter` | Integer variant |
| `Measurement<T>` | Single data-point from an observable callback |
| `MetricReader` | Pull-based collector interface |
| `View` | Instrument selection and aggregation rule |
| `MetricCardinalityLimits` | Cardinality caps for attribute combinations |
| `MetricExporter` | Typedef for `SignalExporter<Metric>` |

```dart
final meter = meterProvider.get('api-service');

// Synchronous instruments
final counter = meter.createCounter<int>(
  'http.server.requests',
  unit: '1',
  description: 'Total incoming HTTP requests',
);

counter.add(1, attributes: Attributes.of({
  'http.method': AttributeValue.string('GET'),
  'http.route': AttributeValue.string('/users/:id'),
  'http.status_code': AttributeValue.int(200),
}));

final histogram = meter.createDoubleHistogram(
  'http.server.duration',
  unit: 'ms',
  description: 'Request latency',
  explicitBucketBoundaries: [1, 5, 10, 25, 50, 100, 250, 500, 1000],
);

final stopwatch = Stopwatch()..start();
// ... handle request ...
histogram.record(stopwatch.elapsedMilliseconds.toDouble(), attributes: Attributes.of({
  'http.method': AttributeValue.string('POST'),
}));

// Asynchronous (observable) instruments — callback-driven
final queueLength = meter.createDoubleObservableGauge(
  'job.queue.length',
  description: 'Current number of pending jobs',
  callback: () => [
    Measurement(jobQueue.length, attributes: Attributes.of({
      'queue': AttributeValue.string('default'),
    })),
  ],
);
```

### Context

The Context API provides immutable, typed key-value propagation decoupled from the platform.

| Type | Role |
|------|------|
| `Context` | Immutable map of typed `ContextKey<T>` → value |
| `ContextKey<T>` | Typed key for safe context access |
| `ContextStorage` | Injectable storage backend for context propagation |
| `ContextTraceExtension` | Convenience `.span` getter on `Context` |
| `ContextBaggageExtension` | Convenience `.baggage` getter on `Context` |
| `spanContextKey` | Pre-defined key for active `Span` |
| `baggageContextKey` | Pre-defined key for `Baggage` |

```dart
// Context is immutable — withValue returns a new instance
final requestIdKey = ContextKey<String>('request-id');
final userIdKey = ContextKey<int>('user-id');

final ctx = Context.root
    .withValue(requestIdKey, 'req-abc-123')
    .withValue(userIdKey, 42);

final reqId = ctx.get(requestIdKey); // 'req-abc-123'
final uid = ctx.get(userIdKey);      // 42

// Built-in extension keys
final activeSpan = ctx.span;          // ContextTraceExtension
final baggage = ctx.baggage;          // ContextBaggageExtension
```

### Baggage

Baggage carries user-defined key-value pairs across process boundaries.

| Type | Role |
|------|------|
| `Baggage` | Immutable map of `String` → `BaggageEntry` |
| `BaggageEntry` | Key-value pair with optional `BaggageEntryMetadata` |
| `BaggageEntryMetadata` | W3C Baggage metadata header value |

```dart
final baggage = const Baggage.empty()
    .setEntry('tenant.id', 'acme-corp')
    .setEntry('environment', 'production', metadata: const BaggageEntryMetadata('env=prod'))
    .setEntry('session.id', 'sess-7f3a');

final tenant = baggage.getEntry('tenant.id')?.value;       // 'acme-corp'

// Immutable — setEntry and removeEntry return new instances
final filtered = baggage.removeEntry('session.id');
// filtered still has tenant.id and environment
```

### Resource

Resource describes the entity producing telemetry — service name, version, host, etc.

| Type | Role |
|------|------|
| `Resource` | Immutable set of `Attributes` describing the telemetry source |
| `ResourceDetector` | Interface for auto-detecting resource attributes |

```dart
final resource = Resource(Attributes.of({
  'service.name': AttributeValue.string('api-gateway'),
  'service.version': AttributeValue.string('3.1.0'),
  'service.namespace': AttributeValue.string('purple-otel'),
  'host.name': AttributeValue.string('node-12'),
}));

// Merge preserves existing keys, overwrites with duplicate
final merged = resource.merge(Resource(Attributes.of({
  'deployment.environment': AttributeValue.string('staging'),
})));

// Platform detectors implement ResourceDetector
abstract interface class ResourceDetector {
  Resource detect();
}
```

### Export

The export layer uses generic interfaces to avoid duplication across signals.

| Type | Role |
|------|------|
| `SignalProvider<T>` | Generic provider: creates `T` by name, supports `forceFlush` / `shutdown` |
| `SignalExporter<T>` | Generic exporter: exports a batch of `T`, returns `ExportResult` |
| `TracerProvider` | Typedef: `SignalProvider<Tracer>` |
| `LoggerProvider` | Typedef: `SignalProvider<Logger>` |
| `MeterProvider` | Typedef: `SignalProvider<Meter>` |
| `SpanExporter` | Typedef: `SignalExporter<Span>` |
| `LogRecordExporter` | Typedef: `SignalExporter<LogRecord>` |
| `MetricExporter` | Typedef: `SignalExporter<Metric>` |
| `ExportResult` | Result with `ExportResultCode` (success, failureRetryable, failureNotRetryable) |
| `ExportResultCode` | Enum for export outcomes |

```dart
// All three signals use the same generic contract
abstract interface class SignalProvider<T> {
  T get(String name, {String? version, String? schemaUrl});
  Future<void> forceFlush();
  Future<void> shutdown();
}

abstract interface class SignalExporter<T> {
  Future<ExportResult> export(List<T> items);
  Future<void> shutdown();
  Future<void> forceFlush();
}

final result = await spanExporter.export(batch);
if (result.isRetryable) {
  // back-off and retry
}
```

### AttributeValue

The sealed `AttributeValue` class provides exhaustive type-safe matching.

| Factory | Wrapped Type | Example |
|---------|-------------|---------|
| `AttributeValue.string` | `String` | `AttributeValue.string('hello')` |
| `AttributeValue.int` | `int` | `AttributeValue.int(42)` |
| `AttributeValue.double` | `double` | `AttributeValue.double(3.14)` |
| `AttributeValue.bool` | `bool` | `AttributeValue.bool(true)` |
| `AttributeValue.list` | `List<AttributeValue>` | `AttributeValue.list([...])` |
| `AttributeValue.bytes` | `Uint8List` | `AttributeValue.bytes(data)` |

```dart
final attr = AttributeValue.string('hello');

// Exhaustive pattern match via .map()
final result = attr.map(
  string: (v) => 'got string: $v',
  int:    (v) => 'got int: $v',
  double: (v) => 'got double: $v',
  bool:   (v) => 'got bool: $v',
  list:   (v) => 'got list: $v',
  bytes:  (v) => 'got ${v.length} bytes',
);

// Convenience: Attributes.fromMap with auto-conversion
final attrs = Attributes.fromMap({
  'name': 'alice',      // → string
  'age': 30,            // → int
  'ratio': 0.95,        // → double
  'active': true,       // → bool
  'tags': ['a', 'b'],   // → list of strings
});
```

---

## Architecture

```
purple_otel_api/
├── lib/
│   ├── purple_otel_api.dart        # Barrel — all public API exports
│   └── src/
│       ├── common/                 # AttributeValue, Attributes, ExportResult, TraceId, SpanId, TraceFlags, InstrumentationScope
│       ├── context/                # Context, ContextKey, ContextStorage, extensions (span, baggage)
│       ├── trace/                  # Tracer, Span, SpanContext, SpanKind, SpanStatus, TraceState, Sampler, SpanProcessor, IdGenerator, SpanLimits, SpanLink, SpanEvent
│       ├── logs/                   # Logger, LogRecord, Severity, LogRecordProcessor
│       ├── metrics/                # Meter, Counter, Histogram, UpDownCounter, Observable instruments (6), MetricReader, View, MetricCardinalityLimits, Measurement
│       ├── baggage/                # Baggage, BaggageEntry, BaggageEntryMetadata
│       ├── resource/               # Resource, ResourceDetector
│       ├── export/                 # SignalProvider<T>, SignalExporter<T>, typedefs (6)
│       └── noop/                   # NoopTracerProvider, NoopTracer, NoopSpan, NoopLoggerProvider, NoopLogger, NoopMeterProvider, NoopMeter
└── test/
    └── purple_otel_api_test.dart   # 22 tests covering all modules
```

---

## Why This Package Exists

PurpleOTel follows the **API / SDK separation** defined by the OpenTelemetry specification:

| Layer | Responsibility | This package |
|-------|---------------|--------------|
| **API** | Interfaces, types, no-op implementations | `purple_otel_api` |
| **SDK** | Real implementations, exporters, processors | `purple_otel_sdk` |

This separation means:

- **Library authors** depend only on `purple_otel_api` to instrument their code. They never pull in HTTP clients, gRPC, or file I/O.
- **Application developers** choose their SDK at the entry point. The API compiles and runs with zero-config no-ops until an SDK is wired in.
- **Testing** is trivial — no-ops never fail, never emit network traffic, and never allocate buffers.
- **Binary size** stays small — the API adds ~40 KB compiled; the full SDK with exporters is opt-in.

No other Dart OTel API achieves true zero-dependency isolation — this package pulls in only `meta`.

---

## Companion Packages

| Package | Pub | Description |
|---------|-----|-------------|
| [purple_otel_sdk](https://pub.dev/packages/purple_otel_sdk) | `purple_otel_sdk` | Full SDK: span/log/metric processors, OTLP exporters, sampling, batching |
| [purple_logger](https://pub.dev/packages/purple_logger) | `purple_logger` | Structured logger with named loggers, levels, and adapters |
| [purple_otel_dio](https://pub.dev/packages/purple_otel_dio) | `purple_otel_dio` | Dio HTTP client interceptor: automatic spans, metrics, and context propagation |
| [purple_otel_flutter](https://pub.dev/packages/purple_otel_flutter) | `purple_otel_flutter` | Flutter integration: navigation spans, widget lifecycle, platform resource detection |

---

---

## Enterprise Support

This package is developed and maintained by **[PurpleSoft S.r.l.](https://www.purplesoft.io)** — a software house based in Monza, Milano, and Lugano (Switzerland), building production-grade software since 2017.

### We solve the impossible

When off-the-shelf solutions aren't enough, our team of elite engineers steps in. We specialize in:

- **Observability & DevOps** — OpenTelemetry, distributed tracing, APM, log aggregation, cloud-native monitoring
- **Flutter & Dart** — high-performance mobile, web, and desktop applications with custom native plugins
- **Cloud-Native Architecture** — microservices, event-driven systems, Kubernetes, serverless
- **AI & Data Science** — machine learning pipelines, big data analytics, LLM integration
- **Enterprise Data Migration** — SAP S/4HANA, ERP transitions, complex ETL at scale
- **Custom Software** — platforms, dashboards, automation, integrations

### Trusted by industry leaders

Our clients include **ABB, Intesa Sanpaolo, Tenaris, Reply, Aubay, Prometeia, Comune di Milano, FIMAP, Altran,** and 50+ other enterprises across Europe.

### Need help with your observability stack?

Whether you're deploying OpenTelemetry at enterprise scale, building custom instrumentation for a complex microservice architecture, or need someone who can debug a production incident at 2AM — **we've been there.**

[Contact PurpleSoft](https://www.purplesoft.io/cerchi-contatti-software-house-a-monza-e-milano/) · [purplesoft.io](https://www.purplesoft.io) · [+39 0362 148 3978](tel:+3903621483978)

---

## License

AGPL-3.0 — see [LICENSE](LICENSE).
