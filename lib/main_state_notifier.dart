// state notifier
// https://github.com/rrousselGit/state_notifier

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<Logger>(create: (_) => ConsoleLogger()),
        StateNotifierProvider<MyStateNotifier, MyState>(
          create: (_) => MyStateNotifier(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              context.select((MyState value) => value.count).toString(),
              style: Theme.of(context).textTheme.headline,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: context.watch<MyStateNotifier>().increment,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

// A Counter example using StateNotifier
// It also uses an external Logger class to log any state change.

// Note that this file does not depend on Flutter and could very well be extracted
// in a different package

abstract class Logger {
  void countChanged(int count);
}

class MyState {
  MyState(this.count);
  final int count;
}

class MyStateNotifier extends StateNotifier<MyState> with LocatorMixin {
  MyStateNotifier() : super(MyState(0));

  void increment() {
    state = MyState(state.count + 1);
  }

  @override
  @protected
  set state(MyState value) {
    if (state.count != value.count) {
      read<Logger>().countChanged(value.count);
    }
    super.state = value;
  }
}

/// A simple [Logger] using [print]
class ConsoleLogger implements Logger {
  @override
  void countChanged(int count) {
    // ignore: avoid_print
    print('Count changed $count');
  }
}
