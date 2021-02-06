import 'package:flutter/material.dart';
import 'package:flutter_structure/components/custom_button.dart';
import 'package:flutter_structure/components/dialog_alert_message.dart';
import 'package:flutter_structure/components/edit_text.dart';
import 'package:flutter_structure/components/widgets.dart';
import 'package:flutter_structure/models/user.dart';
import 'package:flutter_structure/screens/home/home.dart';
import 'package:flutter_structure/services/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../../../services/localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart' as toast;

class SignUpPage extends StatefulWidget {

  Function setLoadingState;

  SignUpPage(this.setLoadingState);

  @override
  _SignUpPageState createState() {
    return _SignUpPageState();
  }

}

class _SignUpPageState extends State<SignUpPage> {

  int accountType = 0;
  TextEditingController emailController = new TextEditingController(), fullNameController = new TextEditingController(),
      passwordController = new TextEditingController(), confirmPasswordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          text('${MyLocalizations.of(context).localization['welcome_to']} ${MyLocalizations.of(context).localization['app_title']}',
              fontSize: textSizeLarge, fontFamily: fontBold)
              .paddingOnly(
              top: spacing_standard_new,
              left: spacing_standard_new,
              right: spacing_standard_new),
          text(MyLocalizations.of(context).localization['let_get_started'],
              textColor: textColorSecondary,
              fontSize: textSizeLargeMedium,
              fontFamily: fontRegular)
              .paddingOnly(
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
          EditText(
            text: MyLocalizations.of(context).localization['confirm_password'],
            isPassword: true,
            mController: confirmPasswordController,
          ).paddingAll(spacing_standard_new),
          EditText(
            text: MyLocalizations.of(context).localization['full_name'],
            isPassword: false,
            mController: fullNameController,
          ).paddingAll(spacing_standard_new),
          text(MyLocalizations.of(context).localization['account_type'],
              textColor: textColorSecondary,
              fontSize: textSizeLargeMedium,
              fontFamily: fontRegular)
              .paddingOnly(
              left: spacing_standard_new, right: spacing_standard_new),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Radio(
                      value: UserItem.ACCOUNT_TYPE_SIMPLE,
                      groupValue: accountType,
                      onChanged: (value) {
                        setState(() {
                          accountType = UserItem.ACCOUNT_TYPE_SIMPLE;
                        });
                      }
                  ),
                  text(MyLocalizations.of(context).localization['simple'],
                      textColor: textColorPrimary,
                      fontSize: textSizeLargeMedium,
                      fontFamily: fontRegular)
                      .paddingOnly(
                      left: spacing_standard_new, right: spacing_standard_new)
                ],
              ),
              Row(
                children: [
                  Radio(
                      value: UserItem.ACCOUNT_TYPE_FARMER,
                      groupValue: accountType,
                      onChanged: (value) {
                        setState(() {
                          accountType = UserItem.ACCOUNT_TYPE_FARMER;
                        });
                      }
                  ),
                  text(MyLocalizations.of(context).localization['farmer'],
                      textColor: textColorPrimary,
                      fontSize: textSizeLargeMedium,
                      fontFamily: fontRegular)
                      .paddingOnly(
                      left: spacing_standard_new, right: spacing_standard_new)
                ],
              )

            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: FittedBox(
              child: CustomButton(
                textContent: MyLocalizations.of(context).localization['sign_up'],
                onPressed: (() {
                  if (emailController.text.length == 0 || fullNameController.text.length == 0
                      || passwordController.text.length == 0) {
                    toast.Toast.show(MyLocalizations.of(context).localization['fill_fields'], context);
                  }
                  else if (passwordController.text != confirmPasswordController.text) {
                    toast.Toast.show(MyLocalizations.of(context).localization['passwords_not_match'], context);
                  }
                  else {
                    registerUser().then((_userCredential) {
                      checkCredential(_userCredential);
                    });
                  }
                }),
              ).paddingOnly(
                  right: spacing_standard_new, bottom: spacing_standard_new),
            ).paddingOnly(
                top: spacing_standard_new, bottom: spacing_standard_new),
          )
        ],
      ),
    );
  }

  checkCredential(UserCredential credential) {
    if (credential != null) {
      User firebaseUser = FirebaseAuth.instance.currentUser;
      credential.user.updateProfile(
          displayName: fullNameController.text
      ).then((value) {
        UserItem _currentUser = new UserItem(firebaseUser.uid, firebaseUser.email, fullNameController.text, accountType: accountType);
        _currentUser.addUserAdditionalFields();
        UserItem.currentUser = _currentUser;
        _currentUser.saveUser().then((value) {
          widget.setLoadingState(false);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
            return HomePage();
          }));
        });
      });
    }
    else {
      widget.setLoadingState(false);
      toast.Toast.show(MyLocalizations.of(context).localization['error_occurred'], context);
    }
  }

  Future<UserCredential> registerUser() async {
    widget.setLoadingState(true);
    UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );
    } on FirebaseAuthException catch (e) {
      widget.setLoadingState(false);
      if (e.code == 'weak-password') {
        showAlertDialogError(MyLocalizations.instanceLocalization['something_wrong'],
            MyLocalizations.instanceLocalization['password_weak']);
      } else if (e.code == 'email-already-in-use') {
        showAlertDialogError(MyLocalizations.instanceLocalization['something_wrong'],
            MyLocalizations.instanceLocalization['email_exist']);
      }
      else {
        toast.Toast.show(MyLocalizations.of(context).localization['error_occurred'], context);
      }
    } catch (e) {
      widget.setLoadingState(false);
      print(e.toString());
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