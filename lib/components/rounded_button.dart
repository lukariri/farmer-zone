import 'package:flutter/material.dart';
import 'package:flutter_structure/services/constants.dart';

class RoundedButton extends StatelessWidget {

  String title;
  IconData icon;
  Function onClick;

  RoundedButton(this.title, this.icon, this.onClick);

  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      onPressed: () {
        this.onClick();
      },
      color: colorPrimary,
      icon: Icon(
        this.icon,
        color: color_white,
      ),
      label: Text(
        title,
        style: TextStyle(
            color: color_white
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0)
      ),
    );
  }

}