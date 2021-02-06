import 'package:flutter/material.dart';
import 'package:flutter_structure/components/custom_button.dart';
import 'package:flutter_structure/components/widgets.dart';
import 'package:flutter_structure/models/order.dart';
import 'package:flutter_structure/models/product_farmer.dart';
import 'package:flutter_structure/models/user.dart';
import 'package:flutter_structure/services/constants.dart';
import 'package:flutter_structure/services/localizations.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:toast/toast.dart' as tst;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ViewCart extends StatefulWidget {

  @override
  _ViewCartState createState() {
    return _ViewCartState();
  }

}

class _ViewCartState extends State<ViewCart> {

  double totalAmount = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    ProductFarmer.appCart.forEach((element) {
      totalAmount += element.price;
    });
  }

  @override
  Widget build(BuildContext context) {
    double expandHeight = MediaQuery.of(context).size.width * 1.1;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: app_background,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                height: 60,
                width: width,
                margin: EdgeInsets.only(right: spacing_standard_new),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: icon_color,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        text(MyLocalizations.of(context).localization['view_cart'],
                            textColor: textColorPrimary,
                            fontSize: textSizeLargeMedium,
                            fontFamily: fontBold),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(spacing_standard_new),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: ShadowColor, blurRadius: 10, spreadRadius: 3)
                  ],
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(spacing_middle),
                      bottomLeft: Radius.circular(spacing_middle)),
                  color: color_white,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        text(MyLocalizations.of(context).localization['cart'],
                            textColor: textColorSecondary)
                      ],
                    ),
                    SizedBox(height: spacing_control + 30),
                    Column(
                      children: List.generate(
                          ProductFarmer.appCart.length,
                              (index) {
                            return Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  text('${ProductFarmer.appCart[index].category.name}', fontFamily: fontMedium),
                                  text('\$ ${ProductFarmer.appCart[index].price}', fontFamily: fontMedium)
                                ],
                              ),
                            );
                          }),
                    ),
                    SizedBox(height: spacing_control+30.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        text('${ProductFarmer.appCart.length} ${MyLocalizations.of(context).localization['items']}'),
                        text('\$ ${totalAmount}', fontFamily: fontMedium),
                      ],
                    ),
                    SizedBox(height: spacing_standard_new),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        text(MyLocalizations.of(context).localization['delete'],
                            textColor: colorPrimary,
                            textAllCaps: true,
                            fontFamily: fontMedium)
                            .onTap(
                              () {
                            setState(() {
                              totalAmount = 0;
                              ProductFarmer.appCart.clear();
                            });

                          },
                        ),
                        SizedBox(width: spacing_standard_new),
                        FittedBox(
                          child: CustomButton(
                            textContent: MyLocalizations.of(context).localization['checkout'],
                            onPressed: (() {
                              setState(() {
                                isLoading = true;
                              });
                              Order order = Order();
                              order.dateTime = DateTime.now();
                              order.userId = UserItem.currentUser.userId;
                              order.addOrder(ProductFarmer.appCart).then((value) {
                                if (value) {
                                  tst.Toast.show(MyLocalizations.of(context).localization['order_sent'], context);
                                  setState(() {
                                    totalAmount = 0;
                                    ProductFarmer.appCart.clear();
                                  });
                                }
                                else {
                                  tst.Toast.show(MyLocalizations.of(context).localization['error_occurred'], context);
                                }
                                setState(() {
                                  isLoading = false;
                                });
                              });
                            }),
                          ),
                        ),
                        SizedBox(height: spacing_standard_new),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

}