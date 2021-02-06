import 'package:flutter/material.dart';
import 'package:flutter_structure/components/widgets.dart';
import 'package:flutter_structure/services/constants.dart';

class CustomButton extends StatefulWidget {

  var textContent;
  VoidCallback onPressed;
  var isStroked = false;
  var height = 50.0;
  var radius = 5.0;
  var bgColors = colorPrimary;
  var color = colorPrimary;

  CustomButton({@required this.textContent, @required this.onPressed, this.isStroked = false, this.height = 50.0, this.radius = 5.0, this.color, this.bgColors = colorPrimary});

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
        alignment: Alignment.center,
        child: text(widget.textContent,
            textColor: widget.isStroked ? colorPrimary : color_white, fontSize: textSizeLargeMedium, isCentered: true, fontFamily: fontSemiBold, textAllCaps: true),
        decoration: widget.isStroked ? boxDecoration(bgColor: Colors.transparent, color: colorPrimary) : boxDecoration(bgColor: widget.bgColors, radius: widget.radius),
      ),
    );
  }
}