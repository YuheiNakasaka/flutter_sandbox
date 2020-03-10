import 'package:flutter/material.dart';

void main() => runApp(Dummy());

class Dummy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: Center(
          child: Text('main.dart'),
        ),
      ),
    );
  }
}
