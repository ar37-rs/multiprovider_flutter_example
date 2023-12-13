import 'package:flutter/material.dart';
import 'package:myapp/states.dart';
import 'package:myapp/provider_utils.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Counter()),
        ChangeNotifierProvider(create: (_) => ThemeOption()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: context.watch<ThemeOption>().currentTheme,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispatching Context In MultiProvider Example'),
      ),
      body: Center(child: consumerCxt((context) {
        ThemeOption getThemeOption = context.watch<ThemeOption>();
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            getThemeOption.isTicking
                ? const Text("Timer is ticking for 5 seconds...")
                : FloatingActionButton(
                    onPressed: () =>
                        context.read<Counter>().incrementDispatch(context),
                    tooltip:
                        'Increment and then change theme (Odd int = Dark, Even int = Light)',
                    child: const Icon(Icons.add),
                  ),
            const Text(''),
            const Count(),
            const Text(''),
            if (!getThemeOption.isTicking)
              FloatingActionButton(
                onPressed: () => context.read<Counter>().decrement(),
                tooltip: 'Decrement',
                child: const Icon(Icons.remove),
              )
          ],
        );
      })),
      floatingActionButton: consumerCxt((context) {
        return context.watch<ThemeOption>().isTicking
            ? const CircularProgressIndicator()
            : FloatingActionButton(
                tooltip: "Change theme on tick",
                child: context.watch<ThemeOption>().currentTheme.brightness ==
                        Brightness.light
                    ? const Icon(Icons.toggle_on)
                    : const Icon(Icons.toggle_off),
                onPressed: () {
                  context.read<ThemeOption>().tickThemeDispatch(context);
                },
              );
      }),
    );
  }
}

class Count extends StatelessWidget {
  const Count({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${context.watch<Counter>().count}',
      key: const Key('counterState'),
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
