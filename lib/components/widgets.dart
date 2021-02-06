import 'package:flutter/material.dart';
import '../services/constants.dart';

Widget text(String text,
    {var fontSize = textSizeMedium,
      textColor = textColorPrimary,
      var fontFamily = fontRegular,
      var isCentered = false,
      var maxLine = 1,
      var latterSpacing = 0.25,
      var textAllCaps = false,
      var isLongText = false}) {
  return Text(
    textAllCaps ? text.toUpperCase() : text,
    textAlign: isCentered ? TextAlign.center : TextAlign.start,
    maxLines: isLongText ? null : maxLine,
    style: TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      color: textColor,
      height: 1.5,
      letterSpacing: latterSpacing,
    ),
  );
}

BoxDecoration boxDecoration({double radius = 10.0, Color color = Colors.transparent, Color bgColor = color_white, double borderWidth = 1.0, var showShadow = false}) {
  return BoxDecoration(
      color: bgColor,
      //gradient: LinearGradient(colors: [bgColor, whiteColor]),
      boxShadow: showShadow ? [BoxShadow(color: ShadowColor, blurRadius: 10, spreadRadius: 3)] : [BoxShadow(color: Colors.transparent)],
      border: Border.all(color: color, width: borderWidth),
      borderRadius: BorderRadius.all(Radius.circular(radius)));
}

Widget mTitle(double width, var icon, var value, var onTap, var subValue, var bgColors, {showIcon: true}) {
  return GestureDetector(
    onTap: () {
      onTap();
    },
    child: Container(
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              (showIcon)?
              Container(
                margin: EdgeInsets.only(right: spacing_standard_new),
                decoration:
                BoxDecoration(shape: BoxShape.circle, color: bgColors),
                width: width * 0.12,
                height: width * 0.12,
                padding: EdgeInsets.all(width * 0.03),
                child: Icon(icon, color: color_white),
              ): Container(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  text(value, fontFamily: fontMedium),
                  text(subValue, textColor: textColorSecondary),
                ],
              )
            ],
          ),
          Icon(Icons.keyboard_arrow_right,
              color: textColorSecondary)
        ],
      ),
    ),
  );
}