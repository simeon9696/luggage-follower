import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class NavigationDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(

      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image:  AssetImage('assets/images/luggage.jpg'))),
              child: Stack(children: <Widget>[
                Positioned(
                    bottom: 12.0,
                    left: 16.0,
                    child: Text("Luggage Follower",
                        style: TextStyle(fontFamily: "Avenir", fontSize: 25.0),
                    )
                ),
              ])
          ),
          Divider(
              height: 3.0, color: Colors.pinkAccent
          ),
          ListTile(
              title: Text("Home"),
              trailing: Icon(Icons.home),
              onTap: () {
                Navigator.pop(context);
                //Navigator.pushNamed(context, '/home');
              }
          ),
          ListTile(
              title: Text("Add Device"),
              trailing: Icon(Icons.add),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/adddevice');
              }
          ),
          ListTile(
              title: Text("Locate Luggage"),
              trailing: Icon(Icons.location_on),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/luggagelocation');
              }
          ),
          ListTile(
            title: Text("Settings"),
            trailing: Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            }
          ),
          ListTile(
              title: Text("About"),
              trailing: Icon(Icons.person),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/about');
              }
          ),
        ],
      ),
    );
  }
}
