import 'dart:async' show Future, StreamSubscription;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'applicationbar.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';
import 'package:luggagefollower/scheduler.dart';

class AddDevice extends StatefulWidget {
  @override
  _AddDeviceState createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  //Status of devices
  String _scanningStatus = 'No supported devices yet. Click button below to start scanning';
  String _noDevices ='No devices found. Please rescan.';
  //List<BluetoothDiscoveryResult> _devices;
  bool _discoveryDone = false;
  bool _discoveringDevices =false;
  bool _noDevicesFound =true;
  bool _isConnecting = false;
  StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;
  List<BluetoothDiscoveryResult> _devices = List<BluetoothDiscoveryResult>();


  //get instance of Bluetooth Serial
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

  Future<void> _neverSatisfied() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bluetooth Disabled'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bluetooth needs to be on to perform scan.'),
                Text('Would you like to turn it on now?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () async{
                Navigator.of(context).pop();
                await bluetooth.requestEnable();
                startDeviceDiscovery();
              },
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void startDeviceDiscovery() async{

    bool deviceBluetoothAvail = await bluetooth.isEnabled;
    bool deviceBluetoothEn = await bluetooth.isAvailable;

    if(deviceBluetoothEn && deviceBluetoothAvail){
      getData();
    }
    else{
      _neverSatisfied();
    }

  }


  void getData() async {



      setState(() {
        _devices = List<BluetoothDiscoveryResult>();
        _noDevicesFound =false;
        _discoveryDone = false;
        _discoveringDevices=true;
      });

      _streamSubscription = FlutterBluetoothSerial.instance.startDiscovery().listen((r) {


         setState(() { _devices.add(r); });
         print(r.device.name);
      });

      showFlutterToastMessage('Beginning scan...');
      _streamSubscription.onDone(() {
        showFlutterToastMessage('Scan complete! Press plus button to rescan if needed');
        setState(() {
          _discoveryDone = true;
          _discoveringDevices=false;

          if(_devices.length > 0){
            _noDevicesFound =false;
          }else{
            _noDevicesFound =true;
          }
          for(var device in _devices){
            print(device.device.name);
          }
        });
      });
  }

  Future<bool> connectToDevice( BluetoothDiscoveryResult deviceToConnect, Schedule schedule,FlutterBluetoothSerial instance) async {
    bool bonded = false;
    setState(() {
      _isConnecting =true;
    });
    if(_devices != null){

      print('Bonding to ${deviceToConnect.device.address}...');
      bonded = await FlutterBluetoothSerial.instance.bondDeviceAtAddress(deviceToConnect.device.address);
      BluetoothConnection luggageFollowerDevice = await BluetoothConnection.toAddress(deviceToConnect.device.address);
      print('Bonding with ${deviceToConnect.device.address} was ${bonded ? 'succesful' : 'failed'}.');
      if(bonded ==true){
        showFlutterToastMessage("Pairing and connection to ${deviceToConnect.device.name} successful");
        schedule.device = deviceToConnect;
        schedule.connectionInstance = instance;
        schedule.luggageStat = "Connected";
        schedule.bluetoothStat ="Enabled";
        schedule.bluetoothInstance = luggageFollowerDevice;
        await bluetooth.cancelDiscovery();
        Navigator.pop(context);
      }
      else{
        showFlutterToastMessage("Pairing and connection to ${deviceToConnect.device.name} failed");
        setState(() {
          _isConnecting =false;
        });
      }
    }else{
      showFlutterToastMessage("No device to connect to");

    }
    return bonded;
  }

  void showFlutterToastMessage(String message){
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 2,
      backgroundColor: Colors.grey[900],
      textColor: Colors.pinkAccent,
      fontSize: 20.0,
    );
  }
  @override
  Widget build(BuildContext context) {
    final schedule = Provider.of<Schedule>(context);
    var finalWidget, noDeviceWidget, devicesFoundWidget;

    noDeviceWidget = Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: ApplicationBar(title:'Devices'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_noDevicesFound && _discoveryDone? _noDevices: _scanningStatus),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.pink,
        splashColor: Colors.white,
        onPressed: () {
          startDeviceDiscovery();

        },
        child: Icon(Icons.add),

      ),
    );

    devicesFoundWidget = Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: ApplicationBar(title: 'Devices'),
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 15),
            child:Text('Discovered Devices'),
          ),

          Flexible(
            child: ListView.builder(
                itemCount: _devices.length,
                itemBuilder: (context,index) {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 0),
                          child: ListTile(
                            title: Text((_devices[index].device.name == null? _devices[index].device.address: _devices[index].device.name)),
                            trailing: Icon(Icons.add),
                            onTap: () async{
                              print('Tapping ${_devices[index].device.name}');
                              //deviceSelectedWidget = CircularProgressIndicator();
                              connectToDevice(_devices[index],schedule, bluetooth);
                            }, //devices[index].device.toString()
                          ),
                        ),
                        Divider(height: 3.0, color: Colors.grey),
                      ],
                    ),
                  );
                }
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.pink,
        splashColor: Colors.pinkAccent,
        onPressed: () {
          if (!_discoveringDevices) {
            startDeviceDiscovery();
          } else {
            showFlutterToastMessage("Scanning in progress. Wait till completion to re-scan");
          }
        },
        child: (_discoveringDevices || _isConnecting? CircularProgressIndicator(

            backgroundColor: Colors.pinkAccent,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            value:null,
            strokeWidth: 1.0)
            : Icon(Icons.add)
        ),
      ),
    );

    if(_noDevicesFound == true){
      finalWidget = noDeviceWidget;
    }else if(_discoveringDevices ==true || _discoveryDone ==true){
      finalWidget = devicesFoundWidget;
    }
    return finalWidget;
  }

}