# PurpleOTel API

[![Pub Version](https://img.shields.io/pub/v/purple_otel_api.svg)](https://pub.dev/packages/purple_otel_api)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)
[![Dart](https://img.shields.io/badge/dart-%3E%3D3.2.0-blue.svg)](https://dart.dev)

OpenTelemetry API for Dart — the foundation for observability in every Dart and Flutter application.

Zero external dependencies. Pure Dart interfaces, no-op implementations, and semantic conventions following the [OpenTelemetry specification](https://opentelemetry.io/docs/specs/otel/).

## Features

- **Zero dependencies** — only `meta`, nothing else
- **Full OTel signal coverage** — Traces, Logs, Metrics, Baggage, Context, Resource
- **Sealed `AttributeValue`** — type-safe attribute values (string, int, double, bool, list, bytes)
- **Immutable `Context`** — zone-based context propagation via injectable `ContextStorage`
- **Generic `SignalProvider<T>`** — DRY interfaces: one pattern, three signals
- **Generic `SignalExporter<T>`** — reusable export contract across all signals
- **No-op implementations** — safe defaults when no SDK is configured
- **OpenTelemetry 1.29+ compliant** — SpanKind, SpanLimits, IdGenerator, View API, cardinality limits

## Quick Start

```dart
import 'package:purple_otel_api/purple_otel_api.dart';

// Use no-op API (safe, returns no-op implementations)
final tracer = NoopTracerProvider().get('my-component');
final span = tracer.startSpan('operation');
span.setAttribute('key', AttributeValue.string('value'));
span.end(); // NoopSpan — silently discarded
```

## API Overview

### Traces

```dart
final tracer = tracerProvider.get('my-service', version: '1.0.0');
final span = tracer.startSpan(
  'GET /users',
  kind: SpanKind.server,
  attributes: Attributes.of({'http.method': AttributeValue.string('GET')}),
);
span.addEvent('cache.miss', attributes: Attributes.of({'key': AttributeValue.string('users:42')}));
span.setStatus(SpanStatus.ok);
span.end();
```

### Logs

```dart
final logger = loggerProvider.get('auth-service');
logger.emit(LogRecord(
  timestamp: DateTime.now(),
  observedTimestamp: DateTime.now(),
  severityNumber: Severity.info,
  severityText: 'INFO',
  body: AttributeValue.string('User authenticated'),
  attributes: Attributes.fromMap({'user.id': '42', 'auth.method': 'oauth2'}),
));
```

### Metrics

```dart
final meter = meterProvider.get('api-service');
final counter = meter.createCounter('http.requests', unit: '1', description: 'Total HTTP requests');
counter.add(1, attributes: Attributes.of({'method': AttributeValue.string('GET'), 'status': AttributeValue.int(200)}));

final histogram = meter.createDoubleHistogram('http.duration', unit: 'ms');
histogram.record(42.5, attributes: Attributes.of({'method': AttributeValue.string('POST')}));
```

### Context & Baggage

```dart
final ctx = Context.root.withValue(ContextKey<String>('request-id'), 'abc-123');
final baggage = const Baggage.empty()
    .setEntry('tenant', 'acme-corp')
    .setEntry('environment', 'production');
```

## Architecture

```
purple_otel_api/
├── lib/
│   ├── purple_otel_api.dart      # Barrel — all public API
│   └── src/
│       ├── common/               # AttributeValue, Attributes, ExportResult, TraceId, SpanId
│       ├── context/              # Context, ContextKey, ContextStorage, extensions
│       ├── trace/                # Tracer, Span, SpanContext, Sampler, SpanProcessor
│       ├── logs/                 # Logger, LogRecord, Severity, LogRecordProcessor
│       ├── metrics/              # Meter, instruments, MetricReader, View, cardinality
│       ├── baggage/              # Baggage, BaggageEntry
│       ├── resource/             # Resource, ResourceDetector
│       ├── export/               # SignalProvider<T>, SignalExporter<T>
│       └── noop/                 # Noop implementations for all signals
```

## Companion Packages

| Package | Description |
|---------|-------------|
| [purple_otel_sdk](https://pub.dev/packages/purple_otel_sdk) | Full SDK implementation with OTLP exporters |
| [purple_logger_otel_sdk](https://pub.dev/packages/purple_logger_otel_sdk) | Bridge: purple_logger → PurpleOTel |
| [purple_otel_http](https://pub.dev/packages/purple_otel_http) | Auto-instrumentation for package:http |

## License

Apache-2.0 — see [LICENSE](LICENSE).
