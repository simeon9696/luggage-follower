import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'applicationbar.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class AddDevice extends StatefulWidget {
  @override
  _AddDeviceState createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationBar(title: 'Add Device'),
      body: Center(
        child: Column(
          children: <Widget>[
            floating
          ],
        ),
      ),
    );
  }
}
