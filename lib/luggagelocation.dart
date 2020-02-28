import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:luggagefollower/scheduler.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:async';

const double CAMERA_ZOOM = 25;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(42.747932,-71.167889);
const LatLng DEST_LOCATION = LatLng(37.335685,-122.0605916);

class LuggageLocation extends StatefulWidget {
  @override
  _LuggageLocationState createState() => _LuggageLocationState();
}

class _LuggageLocationState extends State<LuggageLocation> {
  GoogleMapController mapController;
  Set<Marker> _markers = Set<Marker>();

  Location location = Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;


  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;
  // the user's initial location and current location
  // as it moves
  LocationData currentLocation;
  // a reference to the destination location
  LocationData destinationLocation;
  // wrapper around the location API
  Location lock;

  String _latitude ='';
  String _longitude='';
  String _suitcaselatitude ='';
  String _suitcaselongitude='';
  String _satelliteCount ='';
  void setPermissions() async{
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return;
      }
    }
  }

  _getLocation() async {
    var currentLocation;
    try {
      //currentLocation = await location.getLocation();

      location.onLocationChanged().asBroadcastStream().listen((LocationData currentLoc) async{

        print(currentLoc.latitude);
        print(currentLoc.longitude);
        currentLocation = currentLoc;
        CameraPosition cPosition = CameraPosition(
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING,
          target: LatLng(currentLoc.latitude,
              currentLoc.longitude),
        );

        mapController.animateCamera(CameraUpdate.newCameraPosition(cPosition));


        setState((){ //rebuild the widget after getting the current location of the user
          _latitude =  currentLoc.latitude.toString();
          _longitude =  currentLoc.longitude.toString();
        });
      });
    } on Exception {
      currentLocation = null;
    }
  }


  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  void _onMapCreated(GoogleMapController controller) async{
    mapController = controller;

    rootBundle.loadString('assets/map_style.txt').then((mapStyleString) {
      mapController.setMapStyle(mapStyleString);
    });

  }




  void _start(BuildContext context, Schedule schedule) async{
    String r ='';
    List<String> split;
    Stream f = schedule.bluetoothData;

    f.listen((event) {
      if(r.indexOf('\n')>0){
        r = "";
      }
      r += ascii.decode(event);
      if(r.length > 23){
        split = r.split(',');
        setState(() {
          _suitcaselongitude = split[0];
          _suitcaselatitude = split[1];
          _satelliteCount = split[2];


          // destination pin
          _markers.add(Marker(
            markerId: MarkerId('luggagePin'),
            position: LatLng(double.parse(_suitcaselatitude), double.parse(_suitcaselongitude)),

          ));
        });

      }
    });
  }

  @override
  void initState() {
    _getLocation();
    super.initState();
  }

  Future<bool> _willPopCallback() async {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    Navigator.pop(context);
    return true;
  }



  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    final schedule = Provider.of<Schedule>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => _start(context, schedule));
    setPermissions();
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: _kLake,
            onMapCreated: _onMapCreated,
            markers: _markers,
          ),
          Positioned(
            top: 30,
            child: Container(
              height: 30,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: Text('Luggage Location',style: Theme.of(context).textTheme.headline5,),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 20,
            child: Container(
              height:200,
              //padding: EdgeInsets.symmetric(vertical: 10, horizontal: 90),
              width: MediaQuery.of(context).size.width - 40,
              alignment: Alignment.center,

              child: Card(
                elevation: 2,
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
                          child: Text('Current Position',style: Theme.of(context).textTheme.headline6,),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                              child: Text('Longtitude',style: Theme.of(context).textTheme.bodyText1,),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                              child: Text('Latitude',style: Theme.of(context).textTheme.bodyText1,),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                              child: Text(_longitude,style: Theme.of(context).textTheme.bodyText1,),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                              child: Text(_latitude,style: Theme.of(context).textTheme.bodyText1,),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40.0, 30.0, 40.0, 0.0),
                          child: Text('Suitcase Position',style: Theme.of(context).textTheme.headline6),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                              child: Text('Longtitude',style: Theme.of(context).textTheme.bodyText1,),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                              child: Text('Latitude',style: Theme.of(context).textTheme.bodyText1,),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                              child: Text(_suitcaselongitude ==''? 'N/A' : _suitcaselongitude ,style: Theme.of(context).textTheme.bodyText1,),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                              child: Text(_suitcaselatitude==''? 'N/A' :_suitcaselatitude ,style: Theme.of(context).textTheme.bodyText1,),
                            ),
                          ],
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



