import 'package:flutter/material.dart';
import 'package:flutter_structure/components/widgets.dart';
import 'package:flutter_structure/services/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../services/localizations.dart';
import 'components/sign_in_page.dart';
import 'components/sign_up_page.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AppConnection extends StatefulWidget {

  bool isSignIn = true, isLoading = false;

  @override
  _AppConnectionState createState() {
    return _AppConnectionState();
  }

}

class _AppConnectionState extends State<AppConnection> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_background,
      body: ModalProgressHUD(
        inAsyncCall: widget.isLoading,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: spacing_large,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: color_white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: const Radius.circular(20.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: ShadowColor,
                          blurRadius: 20.0,
                          offset: Offset(0.0, 0.9))
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        text(MyLocalizations.of(context).localization['sign_in'],
                            textColor: widget.isSignIn == true
                                ? textGreenColor
                                : textColorPrimary,
                            fontSize: textSizeLargeMedium,
                            fontFamily: fontBold)
                            .paddingAll(spacing_standard_new)
                            .onTap(() {
                          widget.isSignIn = true;
                          setState(() {});
                        }),
                        text(MyLocalizations.of(context).localization['sign_up'],
                            textColor: widget.isSignIn == false
                                ? textGreenColor
                                : textColorPrimary,
                            fontSize: textSizeLargeMedium,
                            fontFamily: fontBold)
                            .paddingAll(spacing_standard_new)
                            .onTap(() {
                          widget.isSignIn = false;
                          setState(() {});
                        })
                      ],
                    ),
                    widget.isSignIn? SignInPage(this.setLoadingState): SignUpPage(this.setLoadingState)
                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

  setLoadingState(bool _isLoading) {
    setState(() {
      widget.isLoading = _isLoading;
    });
  }

}