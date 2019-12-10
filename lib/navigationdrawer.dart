import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luggagefollower/settings.dart';


import 'home.dart';
import 'about.dart';
import 'settings.dart';


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
                        style: Theme.of(context).textTheme.display1)
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
               /// Navigator.pushReplacementNamed(context, '/home');
                Navigator.pushReplacementNamed(context, '/home');
              }
          ),
          ListTile(
            title: Text("Add Device"),
            trailing: Icon(Icons.add),
          ),
          ListTile(
            title: Text("Settings"),
            trailing: Icon(Icons.settings),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            }
          ),
          ListTile(
              title: Text("About"),
              trailing: Icon(Icons.person),
              onTap: () {
                Navigator.pushNamed(context, '/about');
              }
          ),
        ],
      ),
    );
  }
}
