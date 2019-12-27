import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

class LuggageLocation extends StatefulWidget {
  @override
  _LuggageLocationState createState() => _LuggageLocationState();
}

class _LuggageLocationState extends State<LuggageLocation> {
  GoogleMapController mapController;

  String _latitude ='';
  String _longitude='';
  void setPermissions() async{
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.location]);
  }

  _getLocation() async {
    var location = new Location();
    var currentLocation;
    try {
      //currentLocation = await location.getLocation();

      location.onLocationChanged().listen((LocationData currentLocation) {
        print(currentLocation.latitude);
        print(currentLocation.longitude);
        setState((){ //rebuild the widget after getting the current location of the user
          _latitude =  currentLocation.latitude.toString();
          _longitude =  currentLocation.longitude.toString();
        });
      });


    } on Exception {
      currentLocation = null;
    }
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

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
          ),
          Positioned(
            top: 30,
            child: Container(
              height: 30,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: Text('Luggage Location',style: Theme.of(context).textTheme.title,),
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
                child: Column(
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 0.0),
                      child: Text('Suitcase Telemetry', style: Theme.of(context).textTheme.title),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Latitude'),
                              ),
                              Text(_latitude),
                            ]
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Longitude'),
                              ),
                              Text(_longitude)
                            ]
                          ),
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



