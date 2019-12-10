import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class LuggageFollow extends StatefulWidget {
  @override
  _LuggageFollowState createState() => _LuggageFollowState();

}

class _LuggageFollowState extends State<LuggageFollow> {

  getData() async {
    //get instance of Bluetooth Serial
    FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

    //define list item for class of Bluetooth devices
    List<BluetoothDevice> _devicesList = [];

    //define list item for class of Discovered Bluetooth devices
    List<BluetoothDiscoveryResult> _ddevicesList =[];

    BluetoothDevice _device;

    bool _connected = false;
    bool _pressed = false;
    _ddevicesList = await bluetooth.startDiscovery().toList();
    for(var device in _ddevicesList){
      print(device.device);
    }
    //gets devices stored on device
    _devicesList = await bluetooth.getBondedDevices();
    for(var device in _devicesList){
      print(device.name);
    }

  }
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        child: Text('Scan'),
        onPressed: getData,
      ),

    );
  }
}
