import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';

import 'applicationbar.dart';

class SettingsData with ChangeNotifier {
  bool feet;
  bool metres;
  bool goingOutOfRangeAlert;
  bool outOfRangeAlert;

  SettingsData({this.feet, this.metres, this.goingOutOfRangeAlert,this.outOfRangeAlert});
}

class Settings extends StatefulWidget {


  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  static bool _isFeetChecked   = false;
  static bool _isMetersChecked = true;
  static bool _isGoingOutOfRangeChecked = false;
  static bool _isOutOfRangeChecked   = false;


  SettingsData data = SettingsData(feet: true, metres: false, goingOutOfRangeAlert: false,outOfRangeAlert: false);




  void updateData(){
    print('$_isFeetChecked ,$_isMetersChecked, $_isGoingOutOfRangeChecked, $_isOutOfRangeChecked');
    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'feet': _isFeetChecked,
      'metres': _isMetersChecked,
      'goingOutOfRangeAlert': _isGoingOutOfRangeChecked,
      'outOfRangeAlert': _isOutOfRangeChecked
    });
  }



  Future<bool> _willPopCallback() async {
    print('$_isFeetChecked ,$_isMetersChecked, $_isGoingOutOfRangeChecked, $_isOutOfRangeChecked');
    //Navigator.pop(context, false);
    await Navigator.pushReplacementNamed(context, '/home', arguments: {
      'feet': _isFeetChecked,
      'metres': _isMetersChecked,
      'goingOutOfRangeAlert': _isGoingOutOfRangeChecked,
      'outOfRangeAlert': _isOutOfRangeChecked,
    });

     return true; // return true if the route to be popped
  }

  void playGoingOutOfRange(){
    AudioCache player = AudioCache(prefix: 'sounds/');
    player.play('goingOutOfRange.mp3');
  }

  void playOutOfRange(){
    AudioCache player = AudioCache(prefix: 'sounds/');
    player.play('outOfRange.mp3');
  }

  @override
  Widget build(BuildContext context) {
      return WillPopScope(
        onWillPop: _willPopCallback,
        child: Scaffold(
          appBar: ApplicationBar(title: 'Settings'),
          body: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20),
                  child: Text('Distance Units')
                ),
                Divider(
                  height: 3.0,
                  color: Colors.pink,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 0),
                  child: CheckboxListTile(
                    title: Text('Distance in feet', style: Theme.of(context).textTheme.body1),
                    value: _isFeetChecked,
                    onChanged: (bool value) {
                      setState(() {
                        _isFeetChecked = value; _isMetersChecked = !value;
                         data.feet = value;
                      });
                    },
                    checkColor: Colors.white,
                    activeColor: Colors.pink,
                    subtitle: Text('1 foot ~ 0.3 metres',style: Theme.of(context).textTheme.display2),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 0),
                  child: CheckboxListTile(
                    title: Text('Distance in metres', style: Theme.of(context).textTheme.body1),
                    value: _isMetersChecked,
                    onChanged: (bool value) {
                      setState(() {
                        _isMetersChecked = value;
                        _isFeetChecked = !value;
                        data.metres =value;
                      });
                    },
                    checkColor: Colors.white,
                    activeColor: Colors.pink,
                    subtitle: Text('1 metre ~ 3 feet',style: Theme.of(context).textTheme.display2),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30.0,horizontal: 20),
                  child: Text('Notifications')
                ),
                Divider(
                    height: 3.0,
                    color: Colors.pink,
                ),
                GestureDetector(
                  onLongPress: (){
                    print('Long press detected');
                    playGoingOutOfRange();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 0),
                    child: CheckboxListTile(
                      title: Text('Going out of Range', style: Theme.of(context).textTheme.body1),
                      value: _isGoingOutOfRangeChecked,
                      onChanged: (bool value) {
                        setState(() {
                          _isGoingOutOfRangeChecked = value;
                          data.goingOutOfRangeAlert = value;
                        });
                      },
                      checkColor: Colors.white,
                      activeColor: Colors.pink,
                      subtitle: Text("Audible 'Going Out of range' - Tap and hold to preview", style: Theme.of(context).textTheme.display2),
                    ),
                  ),
                ),

                GestureDetector(
                  onLongPress: (){
                    print('Long press detected');
                    playOutOfRange();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 0),
                    child: CheckboxListTile(
                      title: Text('Out of Range', style: Theme.of(context).textTheme.body1),
                      value: _isOutOfRangeChecked,
                      onChanged: (bool value) {
                        setState(() {
                          _isOutOfRangeChecked = value;
                          data.outOfRangeAlert =value;
                        });
                      },
                      checkColor: Colors.white,
                      activeColor: Colors.pink,
                      subtitle: Text("Audible 'Out of range' - Tap and hold to preview", style: Theme.of(context).textTheme.display2),
                    ),
                  ),
                ),
              ],
          ),

    ),
      );
  }
}
