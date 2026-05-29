import 'package:purple_otel_api/purple_otel_api.dart';
import 'package:test/test.dart';

void main() {
  group('AttributeValue', () {
    test('string factory creates AttributeValue', () {
      final attr = AttributeValue.string('hello');
      var result = '';
      attr.map(
        string: (v) => result = v,
        int: (v) => fail('unexpected int'),
        double: (v) => fail('unexpected double'),
        bool: (v) => fail('unexpected bool'),
        list: (v) => fail('unexpected list'),
        bytes: (v) => fail('unexpected bytes'),
      );
      expect(result, 'hello');
    });

    test('equality works for same type and value', () {
      expect(AttributeValue.string('a'), AttributeValue.string('a'));
      expect(AttributeValue.int(1), AttributeValue.int(1));
      expect(AttributeValue.double(1.5), AttributeValue.double(1.5));
      expect(AttributeValue.bool(true), AttributeValue.bool(true));
    });

    test('equality fails for different values', () {
      expect(AttributeValue.string('a'), isNot(AttributeValue.string('b')));
      expect(AttributeValue.int(1), isNot(AttributeValue.int(2)));
    });
  });

  group('Attributes', () {
    test('empty creates empty attributes', () {
      expect(const Attributes.empty().isEmpty, isTrue);
      expect(const Attributes.empty().length, 0);
    });

    test('of builds from map', () {
      final attrs = Attributes.of({
        'key1': AttributeValue.string('val1'),
        'key2': AttributeValue.int(42),
      });
      expect(attrs.length, 2);
      expect(attrs.get('key1'), AttributeValue.string('val1'));
      expect(attrs.get('key2'), AttributeValue.int(42));
    });

    test('fromMap converts raw objects', () {
      final attrs = Attributes.fromMap({
        'string_key': 'hello',
        'int_key': 42,
        'double_key': 3.14,
        'bool_key': true,
      });
      expect(attrs.length, 4);
      expect(attrs.get('string_key'), AttributeValue.string('hello'));
      expect(attrs.get('int_key'), AttributeValue.int(42));
    });

    test('merge combines two attribute sets', () {
      final a = Attributes.of({'a': AttributeValue.string('va')});
      final b = Attributes.of({'b': AttributeValue.string('vb')});
      final merged = a.merge(b);
      expect(merged.length, 2);
      expect(merged.get('a'), AttributeValue.string('va'));
      expect(merged.get('b'), AttributeValue.string('vb'));
    });
  });

  group('ExportResult', () {
    test('success has correct code', () {
      final result = ExportResult.success();
      expect(result.isSuccess, isTrue);
      expect(result.isRetryable, isFalse);
    });

    test('failureRetryable has correct code', () {
      final result = ExportResult.failureRetryable('timeout');
      expect(result.isSuccess, isFalse);
      expect(result.isRetryable, isTrue);
    });
  });

  group('Context', () {
    test('root is empty', () {
      final ctx = Context.root;
      final key = ContextKey<String>('test');
      expect(ctx.get(key), isNull);
    });

    test('withValue adds key value pair', () {
      final key = ContextKey<String>('test');
      final ctx = Context.root.withValue(key, 'hello');
      expect(ctx.get(key), 'hello');
    });
  });

  group('Trace types', () {
    test('TraceId invalid', () {
      expect(TraceId.invalid().isValid, isFalse);
    });

    test('TraceId generate creates valid id', () {
      final id = TraceId.generate();
      expect(id.isValid, isTrue);
    });

    test('SpanContext isValid with valid ids', () {
      final ctx = SpanContext(
        traceId: TraceId.generate(),
        spanId: SpanId.generate(),
        traceFlags: TraceFlags.sampled,
      );
      expect(ctx.isValid, isTrue);
      expect(ctx.isSampled, isTrue);
    });
  });

  group('Noop implementations', () {
    test('NoopTracerProvider returns NoopTracer', () {
      final provider = NoopTracerProvider();
      final tracer = provider.get('test');
      expect(tracer, isA<Tracer>());
    });

    test('NoopSpan returns invalid span context', () {
      const span = NoopSpan();
      expect(span.spanContext.isValid, isFalse);
      expect(span.isRecording, isFalse);
    });

    test('NoopLoggerProvider returns NoopLogger', () {
      final provider = NoopLoggerProvider();
      final logger = provider.get('test');
      expect(logger, isA<Logger>());
    });

    test('NoopMeter returns noop instruments', () {
      const meter = NoopMeter();
      expect(meter.createCounter('test'), isA<Counter>());
      expect(meter.createDoubleHistogram('test'), isA<DoubleHistogram>());
    });
  });

  group('Baggage', () {
    test('empty baggage has size 0', () {
      expect(const Baggage.empty().size, 0);
    });

    test('setEntry creates new baggage with entry', () {
      final baggage = const Baggage.empty().setEntry('key1', 'value1');
      expect(baggage.size, 1);
      expect(baggage.getEntry('key1')!.value, 'value1');
    });

    test('removeEntry returns empty when removing last', () {
      final baggage = const Baggage.empty().setEntry('key1', 'value1');
      final removed = baggage.removeEntry('key1');
      expect(removed.size, 0);
    });
  });

  group('InstrumentationScope', () {
    test('creates with required name', () {
      final scope = InstrumentationScope(name: 'test-scope');
      expect(scope.name, 'test-scope');
    });
  });
}
