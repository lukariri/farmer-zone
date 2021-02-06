import 'package:flutter/material.dart';
import 'package:flutter_structure/components/rounded_button.dart';
import 'package:flutter_structure/components/widgets.dart';
import 'package:flutter_structure/models/product_farmer.dart';
import 'package:flutter_structure/models/user.dart';
import 'package:flutter_structure/screens/product_details/product_details.dart';
import 'package:flutter_structure/services/constants.dart';
import 'package:flutter_structure/services/localizations.dart';
import 'package:toast/toast.dart';

class ProductWidget extends StatelessWidget {

  ProductFarmer _productFarmer;

  ProductWidget(this._productFarmer);

  @override
  Widget build(BuildContext context) {

    return InkWell(
      child: Container(
        decoration: boxDecoration(showShadow: true),
        padding: EdgeInsets.fromLTRB(
            spacing_middle, 0, spacing_middle, spacing_middle),
        margin: EdgeInsets.only(
            left: spacing_standard_new,
            right: spacing_standard_new,
            bottom: spacing_standard_new),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  Image.network(
                      _productFarmer.urlImage,
                      fit: BoxFit.fill,
                      height: MediaQuery.of(context).size.width * 0.25),
                  SizedBox(height: spacing_control),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      text('\$ ${_productFarmer.price}', fontSize: textSizeLargeMedium),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      text(_productFarmer.name, fontSize: textSizeLargeMedium, fontFamily: fontMedium),
                    ],
                  ),
                  Container(
                      transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                      child: text(_productFarmer.city.toString(), textColor: textColorSecondary)),
                  (_productFarmer.userId != UserItem.currentUser.userId)?
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Transform.scale(
                        scale: 0.8,
                        child: RoundedButton(
                          MyLocalizations.of(context).localization['add_to_cart'],
                          Icons.add_shopping_cart,
                          () {
                            ProductFarmer.appCart.add(_productFarmer);
                            Toast.show(MyLocalizations.of(context).localization['added_to_cart'], context);
                          }
                        ),
                      )
                    ],
                  ):
                  Container(
                    child: Text(
                      '${_productFarmer.sales} ' + MyLocalizations.of(context).localization['sales'],
                      style: TextStyle(
                        color: colorPrimary,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ProductDetails(this._productFarmer);
        }));
      },
    );

  }

}