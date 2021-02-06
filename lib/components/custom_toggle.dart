import 'package:flutter/material.dart';
import 'package:flutter_structure/services/constants.dart';

class CustomToggle extends StatefulWidget {

  Function onChanged;
  String firstTitle = '', secondTitle = '';

  CustomToggle(this.onChanged, this.firstTitle, this.secondTitle);

  @override
  _CustomToggleState createState() {
    return _CustomToggleState();
  }

}

class _CustomToggleState extends State<CustomToggle> {

  ToggleType selectedType = ToggleType.TOGGLE_TYPE_1;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          RaisedButton(
            onPressed: () {
              setState(() {
                selectedType = ToggleType.TOGGLE_TYPE_1;
              });
              widget.onChanged(ToggleType.TOGGLE_TYPE_1);
            },
            child: Text(
              widget.firstTitle,
              style: TextStyle(
                  color: (selectedType == ToggleType.TOGGLE_TYPE_1)?
                  Colors.white:
                  colorPrimary
              ),
            ),
            color: (selectedType == ToggleType.TOGGLE_TYPE_1)?
            colorPrimary:
            Colors.grey[100],
            shape:  RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0)
                ),
                side: BorderSide(color: colorPrimary)
            ),
          ),
          RaisedButton(
            onPressed: () {
              setState(() {
                selectedType = ToggleType.TOGGLE_TYPE_2;
              });
              widget.onChanged(ToggleType.TOGGLE_TYPE_2);
            },
            child: Text(
              widget.secondTitle,
              style: TextStyle(
                  color: (selectedType == ToggleType.TOGGLE_TYPE_2)?
                  Colors.white:
                  colorPrimary
              ),
            ),
            color: (selectedType == ToggleType.TOGGLE_TYPE_2)?
            colorPrimary:
            Colors.grey[100],
            shape:  RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0)
                ),
                side: BorderSide(color: colorPrimary)
            ),
          ),
        ],
      ),
    );
  }

}

enum ToggleType {
  TOGGLE_TYPE_1,
  TOGGLE_TYPE_2
}