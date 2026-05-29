import 'context.dart';

/// Stores and manages the current [Context] for a logical execution unit.
///
/// [ContextStorage] provides a mechanism to get, attach, and detach contexts
/// within an execution scope (e.g., a thread, isolate, or async zone). The
/// [current] getter returns the active context. Use [attach] to set a new
/// context and receive a token, and [detach] to restore the previous context.
abstract interface class ContextStorage {
  /// The currently active [Context].
  Context get current;

  /// Sets [context] as the current context and returns the previous one.
  ///
  /// The returned [Context] should be passed to [detach] to restore it.
  Context attach(Context context);

  /// Restores the previous [context], typically the one returned by [attach].
  Context detach(Context context);
}
