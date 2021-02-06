import 'package:flutter/material.dart';
import 'package:flutter_structure/components/custom_button.dart';
import 'package:flutter_structure/components/dialog_alert_message.dart';
import 'package:flutter_structure/components/edit_text.dart';
import 'package:flutter_structure/components/widgets.dart';
import 'package:flutter_structure/models/user.dart';
import 'package:flutter_structure/screens/home/home.dart';
import 'package:flutter_structure/services/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/localizations.dart';
import 'package:toast/toast.dart' as toast;

class SignInPage extends StatefulWidget {

  Function setLoadingState;

  SignInPage(this.setLoadingState);

  @override
  _SignInPageState createState() {
    return _SignInPageState();
  }

}

class _SignInPageState extends State<SignInPage> {

  TextEditingController emailController = TextEditingController(), passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          text('${MyLocalizations.of(context).localization['sign_in_to']} ${MyLocalizations.of(context).localization['app_title']}',
              fontSize: textSizeLarge, fontFamily: fontBold)
              .paddingOnly(
              top: spacing_standard_new,
              left: spacing_standard_new,
              right: spacing_standard_new),
          text(
            MyLocalizations.of(context).localization['enter_email_and_password'],
            textColor: textColorSecondary,
            fontSize: textSizeLargeMedium,
          ).paddingOnly(
              left: spacing_standard_new, right: spacing_standard_new),
          EditText(
            text: MyLocalizations.of(context).localization['email_address'],
            isPassword: false,
            mController: emailController,
            keyboardType: TextInputType.emailAddress,
          ).paddingAll(spacing_standard_new),
          EditText(
            text: MyLocalizations.of(context).localization['password'],
            isPassword: true,
            mController: passwordController,
          ).paddingAll(spacing_standard_new),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              CustomButton(
                textContent: MyLocalizations.of(context).localization['sign_in'],
                onPressed: (() {
                  signIn().then((credential) {
                    checkCredential(credential);
                  });
                }),
              ).paddingOnly(
                right: spacing_standard_new, bottom: spacing_standard_new)
                .paddingOnly(
                top: spacing_standard_new, bottom: spacing_standard_new)
            ],
          )
        ],
      ),
    );
  }

  checkCredential(UserCredential credential) async {
    if (credential != null) {
      User firebaseUser = FirebaseAuth.instance.currentUser;
      UserItem _currentUser = new UserItem(firebaseUser.uid, firebaseUser.email, firebaseUser.displayName);
      await _currentUser.getAdditionalFields();
      UserItem.currentUser = _currentUser;
      widget.setLoadingState(false);
      _currentUser.saveUser().then((value) {
        widget.setLoadingState(false);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
          return HomePage();
        }));
      });
    }
    else {
      widget.setLoadingState(false);
      toast.Toast.show(MyLocalizations.of(context).localization['error_occurred'], context);
    }
  }

  Future<UserCredential> signIn() async {
    widget.setLoadingState(true);
    UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );
    } on FirebaseAuthException catch (e) {
      widget.setLoadingState(false);
      if (e.code == 'user-not-found') {
        showAlertDialogError(MyLocalizations.instanceLocalization['something_wrong'],
            MyLocalizations.instanceLocalization['error_user_not_found']);
      } else if (e.code == 'wrong-password') {
        showAlertDialogError(MyLocalizations.instanceLocalization['something_wrong'],
            MyLocalizations.instanceLocalization['error_wrong_password']);
      }
      else {
        toast.Toast.show(MyLocalizations.of(context).localization['error_occurred'], context);
      }
    } catch (e) {
      widget.setLoadingState(false);
      toast.Toast.show(MyLocalizations.of(context).localization['error_occurred'], context);
    }

    return userCredential;
  }

  showAlertDialogError(String title, String description) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => DialogAlertMessage(
          Icons.error,
          title,
          description
      )
      ,
    );
  }

}