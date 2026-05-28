import 'context.dart';

abstract interface class ContextStorage {
  Context get current;
  Context attach(Context context);
  Context detach(Context context);
}
