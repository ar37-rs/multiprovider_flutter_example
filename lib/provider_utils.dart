import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Manage widget using consumer build context (Alias for Consumer class)
Widget consumerCxt(Widget Function(BuildContext) function) {
  return Consumer(builder: (context, _, child) => function(context));
}

extension BuildCxt on BuildContext {
  /// Read state of a class which mixin with ChangeNotifier on this BuildContext.
  T state<T>() {
    return read<T>();
  }
}
