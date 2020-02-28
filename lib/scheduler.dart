import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:location/location.dart';

class Schedule with ChangeNotifier{
  double _distance  =15;
  double get distance => _distance;

  String _textDistance = '';
  String get textDistance => _textDistance;

  String _textUnits= 'metres';
  String get textUnits => _textUnits;

  String _luggageStat= 'Tracking N/A';
  String get luggageStat => _luggageStat;

  String _bluetoothStat= 'Disabled';
  String get bluetoothStat => _bluetoothStat;

  Stream _bluetoothData;
  Stream get bluetoothData => _bluetoothData;

  FlutterBluetoothSerial _connectionInstance;
  FlutterBluetoothSerial get connectionInstance => _connectionInstance;

  BluetoothDiscoveryResult _device;
  BluetoothDiscoveryResult get device => _device;

  BluetoothConnection _bluetoothInstance;
  BluetoothConnection get bluetoothInstance => _bluetoothInstance;

  String _phoneLocation;
  String get phoneLocation => _phoneLocation;

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

  set bluetoothStat (String newBluetoothStat){
    _bluetoothStat = newBluetoothStat;
    notifyListeners();
  }

  set bluetoothData (Stream newStream){
    _bluetoothData = newStream;
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

  set bluetoothInstance (BluetoothConnection newConnection){
    _bluetoothInstance = newConnection;
    notifyListeners();
  }

  set phoneLocation (String newLocation){
    _phoneLocation = newLocation;
    notifyListeners();
  }
}
