import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class Schedule with ChangeNotifier{
  double _distance  =40;
  double get distance => _distance;

  String _textDistance = '';
  String get textDistance => _textDistance;

  String _textUnits= 'N/A';
  String get textUnits => _textUnits;

  String _luggageStat= 'Tracking N/A';
  String get luggageStat => _luggageStat;

  FlutterBluetoothSerial _connectionInstance;
  FlutterBluetoothSerial get connectionInstance => _connectionInstance;

  BluetoothDiscoveryResult _device;
  BluetoothDiscoveryResult get device => _device;

  set distance (double newDistance){
    _distance = newDistance;
    notifyListeners();
  }

  set textDistance (String newTextDistance){
    _textDistance = newTextDistance;
    notifyListeners();
  }

  set textUnits (String newTextUnits){
    _textUnits = newTextUnits;
    notifyListeners();
  }

  set luggageStat (String newLuggageStat){
    _luggageStat = newLuggageStat;
    notifyListeners();
  }

  set device (BluetoothDiscoveryResult newDeviceAddress){
    _device = newDeviceAddress;
    notifyListeners();
  }

  set connectionInstance (FlutterBluetoothSerial newInstance){
    _connectionInstance = newInstance;
    notifyListeners();
  }
}
