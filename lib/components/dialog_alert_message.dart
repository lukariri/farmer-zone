import 'package:flutter/material.dart';
import 'package:flutter_structure/components/widgets.dart';
import '../services/localizations.dart';
import 'package:nb_utils/nb_utils.dart';

class DialogAlertMessage extends StatelessWidget {

  IconData icon;
  String title, description;
  Color iconColor;

  DialogAlertMessage(this.icon, this.title, this.description, {this.iconColor: Colors.red});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: boldTextStyle(color: textPrimaryColor)),
          16.height,
          Text(
            description,
            style: secondaryTextStyle(color: textSecondaryColor),
          ),
          16.height,
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: boxDecoration(bgColor: Theme.of(context).primaryColor, radius: 10),
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: text(MyLocalizations.of(context).localization['ok'], textColor: white, fontSize: 16.0),
              ),
            ),
          )
        ],
      ),
      contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomLeft: Radius.circular(50))),
    );
  }

}