import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_structure/components/widgets.dart';
import 'package:flutter_structure/models/user.dart';
import 'package:flutter_structure/screens/app_connection/app_connection.dart';
import 'package:flutter_structure/screens/view_cart/view_cart.dart';
import 'package:flutter_structure/services/constants.dart';
import '../../services/localizations.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';

import 'fragments/fragment_home.dart';
import 'fragments/fragment_profile.dart';
import 'fragments/fragment_search.dart';
import 'fragments/fragment_stats.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() {
    return _HomePageState();
  }

}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: app_background,
      body: SafeArea(
        child: DefaultTabController(
          length: 4,
          child: Scaffold(
            backgroundColor: app_background,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: colorPrimary,
              title: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(width: spacing_large),
                        text(MyLocalizations.of(context).localization['app_title'],
                            textColor: color_white,
                            fontFamily: fontBold,
                            fontSize: textSizeLargeMedium),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          child: Icon(Icons.shopping_cart),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return ViewCart();
                              }
                            ));
                          },
                        ),
                        SizedBox(width: spacing_standard_new),
                        GestureDetector(
                          child: Icon(FontAwesome.logout),
                          onTap: () {
                            logout();
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
              bottom: TabBar(
                indicatorColor: color_white,
                tabs: [
                  Tab(icon: Icon(Icons.home)),
                  Tab(icon: Icon(Icons.search)),
                  Tab(icon: Icon(Icons.assessment)),
                  Tab(icon: Icon(Icons.account_circle))
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                FragmentHome(),
                FragmentSearch(),
                FragmentStats(),
                FragmentProfile(logout)
              ],
            ),
          ),
        ),
      ),
    );
  }

  logout() {
    try {
      FirebaseAuth.instance.signOut().then((value) {
        UserItem currentUser = UserItem('', '', '');
        currentUser.saveUser();
        UserItem.currentUser = currentUser;
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
          return AppConnection();
        }));
      });
    }
    catch (error) {
      Toast.show(MyLocalizations.of(context).localization['error_occurred'], context);
    }
  }

}