import 'package:flutter/material.dart';

class WaterIntake extends StatefulWidget {
  const WaterIntake({super.key});

  @override
  State<WaterIntake> createState() => _WaterIntakeState();
}

class _WaterIntakeState extends State<WaterIntake> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      if (_counter == 8) {
        _counter = 0;
      } else {
        _counter++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Intake'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 50.0 * _counter / 2.0,
              width: 100.0,
              color: Colors.blue,
            ),
            const Text(
              'You have drank water this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
