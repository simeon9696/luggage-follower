import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'applicationbar.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart';

class LuggageLocation extends StatefulWidget {
  @override
  _LuggageLocationState createState() => _LuggageLocationState();
}

class _LuggageLocationState extends State<LuggageLocation> {
  GoogleMapController mapController;

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
      });
      setState((){ //rebuild the widget after getting the current location of the user

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

  @override
  Widget build(BuildContext context) {
    setPermissions();
    return Stack(
      children: <Widget>[
        GoogleMap(
          mapType: MapType.normal,
          myLocationEnabled: true,
          initialCameraPosition: _kLake,
          onMapCreated: _onMapCreated,
        ),
        Positioned(
          bottom: 50,
          right: 10,
          child: Text('hello world'),
        ),
      ],
    );
  }
}



