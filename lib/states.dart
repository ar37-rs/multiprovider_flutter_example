import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myapp/provider_utils.dart';

/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool
// ignore: prefer_mixin

class Counter with ChangeNotifier, DiagnosticableTreeMixin {
  int _count = 0;
  int get count => _count;

  void decrement() {
    if (count > 0) _count--;
    notifyListeners();
  }

  void increment() {
    _count++;
    notifyListeners();
  }

  void incrementDispatch(BuildContext context) {
    // Note:
    // Don't use context.watch<Counter> inside any dispatching function of the class, otherwise some errors will occur.
    // use context.state<Counter> here to avoid confusion.
    increment();
    _count.isOdd
        ? context.state<ThemeOption>().setCurrentTheme(ThemeOption.dark)
        : context.state<ThemeOption>().setCurrentTheme(ThemeOption.light);
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('count', _count));
  }
}

class ThemeOption with ChangeNotifier {
  // states

  static final ThemeData light = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
    ),
    brightness: Brightness.light,
  );

  static final ThemeData dark = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.black,
    ),
    brightness: Brightness.dark,
  );

  ThemeData _currentTheme = light;

  bool _tick = false;

  // getters
  ThemeData get currentTheme => _currentTheme;
  bool get isTicking => _tick;

  // setters
  void setTick(bool state) {
    _tick = state;
    notifyListeners();
  }

  Timer? timer;

  void setCurrentTheme(ThemeData theme) {
    _currentTheme = theme;
    notifyListeners();
  }

  void tickThemeDispatch(BuildContext context) async {
    if (!isTicking) {
      setTick(true);
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        // Note:
        // Don't use context.watch<Counter> inside any dispatching function of the class, otherwise some errors will occur.
        // use context.state<Counter> here to avoid confusion.
        // ignore: avoid_print
        print("count value: ${context.state<Counter>().count}");
        context.state<Counter>().count.isOdd
            ? _currentTheme = dark
            : _currentTheme = light;
        context.state<Counter>().incrementDispatch(context);
      });
      await Future.delayed(const Duration(seconds: 6));
      timer?.cancel();
      setTick(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }
}
