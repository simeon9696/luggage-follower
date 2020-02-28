import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'applicationbar.dart';

class Dependencies {
  String name;
  String version;

  Dependencies({this.name,this.version});
}

class About extends StatefulWidget {


  @override
  _AboutState createState() => _AboutState();
}
class _AboutState extends State<About>{

  static final int batteryHours = 8;
  final String flutterVersion = "1.15.4-pre.127";
  final String assetName = 'assets/svgs/flutterLogo.svg';
  final String aboutTheApp =
      "'Luggage Follower' uses your phone's bluetooth to connect to a supported device and "
      "calculates the distance between your phone and the supported device. The onboard GPS "
      "allows for accurately pinpointing your luggage location in the event it gets lost. "
      "This also allows the suitcase to turn and follow your every step by comparing your "
      "position with the suitcase and plotting a follow path. "
      "The ${batteryHours}hr battery means it can go as long as you can, with an onboard 5V/2.1A"
      " phone charger, you'll never be left without power.";

  Future<bool> _willPopCallback() async {
    Navigator.pop(context);
    return true; // return true if the route to be popped
  }

  final List<Dependencies> listOfDependencies= [
    Dependencies(name: 'audioplayers', version: '0.13.5'),
    Dependencies(name: 'cupertino_icons', version: '0.1.2'),
    Dependencies(name: 'flutter_bluetooth_serial', version: '0.2.2'),
    Dependencies(name: 'flutter_local_notifications', version: '0.8.4+3'),
    Dependencies(name: 'flutter_launcher_icons', version: '0.7.4'),
    Dependencies(name: 'flutter_svg', version: '0.15.0'),
    Dependencies(name: 'fluttertoast', version: '3.1.3'),
    Dependencies(name: 'google_maps_flutter',version: '0.5.24+1'),
    Dependencies(name: 'location',version: '2.4.0'),
    Dependencies(name: 'permission_handler',version: '4.2.0+hotfix.3'),
    Dependencies(name: 'provider',version:'3.2.0'),
    Dependencies(name: 'splashscreen', version: '1.2.0'),
    Dependencies(name: 'syncfusion_flutter_gauges', version: '17.4.50-beta'),
  ];



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.grey[900],
        appBar: ApplicationBar(title: 'About'),
        body:Center(
          child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25,horizontal: 0),
                  child: Text('Ijaz Mohammed - PRJT3001', style: Theme.of(context).textTheme.bodyText1),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: Divider(
                    height: 3.0,
                    color: Colors.pink,
                    endIndent: 40.0,
                    indent: 40.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 40),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(aboutTheApp, style: Theme.of(context).textTheme.bodyText1,textAlign: TextAlign.center,),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Divider(
                    height: 3.0,
                    color: Colors.pink,
                    endIndent: 40.0,
                    indent: 40.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Built with ', style: Theme.of(context).textTheme.bodyText1),
                      SizedBox(
                        width: 100.0,
                        height: 90.0,
                        child: SvgPicture.asset(
                          assetName,
                          semanticsLabel: 'Flutter Logo',
                          placeholderBuilder: (BuildContext context) => Container(
                              padding: const EdgeInsets.all(30.0),
                              child: const CircularProgressIndicator()),
                        ),
                      ),
                      Text(flutterVersion,style: Theme.of(context).textTheme.bodyText1),
                    ],
                  ),
                ),

                Flexible(
                  child: Scrollbar(
                    child: ListView.builder(
                        itemCount: listOfDependencies.length,
                        itemBuilder: (context,index) {
                          return Container(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 0),
                                  child: ListTile(
                                    title: Text(listOfDependencies[index].name, style: Theme.of(context).textTheme.bodyText2),
                                    trailing: Text(listOfDependencies[index].version,style: Theme.of(context).textTheme.bodyText2),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                    ),
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }
}