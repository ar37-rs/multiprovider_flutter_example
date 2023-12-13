import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Add and manage consumer widget (Alias for Consumer class)
abstract class ConsumerWidget {
  static Widget add(Widget Function(BuildContext) function) {
    return Consumer(builder: (context, _, child) => function(context));
  }
}

extension BuildCxt on BuildContext {
  /// Read state of a class which mixin with ChangeNotifier on this BuildContext.
  T state<T>() {
    return read<T>();
  }
}
