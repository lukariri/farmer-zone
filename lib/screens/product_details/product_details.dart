import 'package:flutter/material.dart';
import 'package:flutter_structure/components/custom_button.dart';
import 'package:flutter_structure/components/widgets.dart';
import 'package:flutter_structure/models/product_farmer.dart';
import 'package:flutter_structure/models/user.dart';
import 'package:flutter_structure/services/constants.dart';
import 'package:flutter_structure/services/localizations.dart';
import 'package:toast/toast.dart';

class ProductDetails extends StatefulWidget {

  ProductFarmer productFarmer;

  ProductDetails(this.productFarmer);

  @override
  State<StatefulWidget> createState() {
    return _ProductDetailsState();
  }

}

class _ProductDetailsState extends State<ProductDetails> {

  @override
  Widget build(BuildContext context) {
    double expandHeight = MediaQuery.of(context).size.width * 1.1;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: app_background,
      body: SafeArea(
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
                      text(MyLocalizations.of(context).localization['product_details'],
                          textColor: textColorPrimary,
                          fontSize: textSizeLargeMedium,
                          fontFamily: fontBold),
                    ],
                  )
                ],
              ),
            ),
            Stack(
              children: <Widget>[
                Container(
                  width: width,
                  padding: EdgeInsets.only(bottom: spacing_standard_new),
                  margin: EdgeInsets.only(
                    top: width * 0.35,
                    left: spacing_standard_new,
                    right: spacing_standard_new,
                  ),
                  decoration: boxDecoration(showShadow: true),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: width * 0.17),
                      text(widget.productFarmer.name,
                          fontFamily: fontMedium,
                          fontSize: textSizeLargeMedium),
                      SizedBox(height: spacing_standard),
                      Container(
                        padding: EdgeInsets.only(
                            left: spacing_control, right: spacing_control),
                        decoration: boxDecoration(
                            radius: spacing_control,
                            bgColor: light_gray_color),
                        child: text(widget.productFarmer.userItem.fullName.toString(),
                            fontSize: textSizeSmall, isCentered: true),
                      ),
                      SizedBox(height: spacing_middle),
                      text('\$ ${widget.productFarmer.price}',
                          fontFamily: fontMedium, fontSize: textSizeNormal),
                      SizedBox(height: spacing_standard_new),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.location_on,
                              size: 35, color: icon_color),
                          text(widget.productFarmer.city,
                              fontFamily: fontMedium,
                              fontSize: textSizeLarge,
                              isCentered: true),
                        ],
                      ),
                      SizedBox(height: spacing_standard_new),
                      (widget.productFarmer.userId != UserItem.currentUser.userId)?
                      FittedBox(
                        child: CustomButton(
                          onPressed: () {
                            ProductFarmer.appCart.add(widget.productFarmer);
                            Toast.show(MyLocalizations.of(context).localization['added_to_cart'], context);
                          },
                          textContent: MyLocalizations.of(context).localization['add_to_cart'],
                        ),
                      ):
                      text(
                        '${widget.productFarmer.sales} ' + MyLocalizations.of(context).localization['sales'],
                        fontFamily: fontMedium,
                        fontSize: textSizeNormal,
                        textColor: colorPrimary
                      ),
                      SizedBox(height: spacing_standard_new),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: EdgeInsets.all(spacing_standard_new),
                    decoration: boxDecoration(showShadow: true),
                    height: width * 0.5,
                    width: width * 0.6,
                    child: Image.network(
                        widget.productFarmer.urlImage,
                      fit: BoxFit.fill
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}