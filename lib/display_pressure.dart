import 'package:flutter/material.dart';
import 'package:flutter_barometer_plugin/flutter_barometer.dart';

class DisplayPressure extends StatelessWidget {
  const DisplayPressure({
    Key? key,
    required Stream<BarometerValue>? barometerStream,
  })  : _barometerStream = barometerStream,
        super(key: key);

  final Stream<BarometerValue>? _barometerStream;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: StreamBuilder<BarometerValue>(
          stream: _barometerStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text('No data');
            }
            return Text(snapshot.data?.inchOfMercury.toString() ?? 'No data',
                style: const TextStyle(fontSize: 10, color: Colors.red));
          }),
    );
  }
}
