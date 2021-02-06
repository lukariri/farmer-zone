import 'package:flutter/material.dart';
import 'package:flutter_structure/components/custom_button.dart';
import 'package:flutter_structure/components/widgets.dart';
import 'package:flutter_structure/models/user.dart';
import 'package:flutter_structure/screens/order_list/order_list.dart';
import 'package:flutter_structure/screens/products_list/products_list.dart';
import 'package:flutter_structure/services/constants.dart';
import 'package:flutter_structure/services/localizations.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';

class FragmentProfile extends StatelessWidget {

  Function logout;
  double width;

  FragmentProfile(this.logout);

  @override
  Widget build(BuildContext context) {

    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: app_background,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                Container(
                  decoration: boxDecoration(showShadow: true),
                  padding: EdgeInsets.all(spacing_middle),
                  margin: EdgeInsets.only(
                      right: spacing_standard_new,
                      left: spacing_standard_new,
                      bottom: spacing_standard_new),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      (UserItem.currentUser.accountType == UserItem.ACCOUNT_TYPE_FARMER)?
                      mTitle(
                          width,
                          FontAwesome5.carrot,
                          MyLocalizations.of(context).localization['products'],
                          (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                              return ProductsList();
                            }));
                          },
                          MyLocalizations.of(context).localization['view_list_products'],
                          colorPrimary
                      ): Container(),
                      (UserItem.currentUser.accountType == UserItem.ACCOUNT_TYPE_FARMER)?
                      mIcon(): Container(),
                      mTitle(
                          width,
                          Icons.shopping_cart,
                          MyLocalizations.of(context).localization['orders'],
                          () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                              return OrderList();
                            }));
                          },
                          MyLocalizations.of(context).localization['view_list_orders'],
                          colorPrimary
                      ),
                      mIcon(),
                      mTitle(
                          width,
                          FontAwesome.logout,
                          MyLocalizations.of(context).localization['logout'],
                          () {
                            logout();
                          },
                          MyLocalizations.of(context).localization['logout_from_app'],
                          colorPrimary
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget mIcon() {
    return Row(
      children: <Widget>[
        Container(
            width: 0.5,
            height: width * 0.1,
            color: view_color,
            margin: EdgeInsets.only(left: width * 0.06)),
        Container(
            height: 0.5,
            color: view_color,
            margin: EdgeInsets.only(
                left: width * 0.1,
                top: spacing_control,
                bottom: spacing_control)),
      ],
    );
  }

}