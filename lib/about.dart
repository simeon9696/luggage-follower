import 'package:flutter/material.dart';
import 'navigationdrawer.dart';
import 'applicationbar.dart';

class About extends StatelessWidget {
  //final String title;
  //About({Key key, @required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.grey[900],
      appBar: ApplicationBar(title: 'About'),
      drawer: NavigationDrawer(),
      body:Center(
        child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                child: Text('Author', style: Theme.of(context).textTheme.body2),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                child: Text('Ijaz Mohammed', style: Theme.of(context).textTheme.body1),
              ),
            ]),
      ),
    );
  }
}