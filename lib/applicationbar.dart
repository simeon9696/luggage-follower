import 'package:flutter/material.dart';


class ApplicationBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  ApplicationBar({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline5,
      ),
      centerTitle: true,
      backgroundColor: Colors.grey[900],
      elevation: 0,
    );
  }
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}