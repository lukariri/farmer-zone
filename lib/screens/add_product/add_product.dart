import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_structure/components/custom_button.dart';
import 'package:flutter_structure/components/dialog_pick_category.dart';
import 'package:flutter_structure/components/edit_text.dart';
import 'package:flutter_structure/components/rounded_button.dart';
import 'package:flutter_structure/components/widgets.dart';
import 'package:flutter_structure/models/product_farmer.dart';
import 'package:flutter_structure/models/user.dart';
import 'package:flutter_structure/services/constants.dart';
import 'package:flutter_structure/services/localizations.dart';
import 'package:flutter_structure/services/utils.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:geocoder/geocoder.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart' as tst;
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _AddProductState();
  }

}

class _AddProductState extends State<AddProduct> {

  ProductFarmer _productFarmer;
  bool isLoading = false;
  TextEditingController _editingControllerPrice = TextEditingController();
  TextEditingController _editingControllerProductName = TextEditingController();

  File _image;
  final picker = ImagePicker();

  @override
  void initState() {
    _productFarmer = ProductFarmer(UserItem.currentUser.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: app_background,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 68),
        child: title1(MyLocalizations.of(context).localization['add_product'], color_white,
            textColorPrimary, context),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: SingleChildScrollView(
          child: Container(
            width: width,
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
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.width * 0.4,
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25.0)),
                            color: Colors.grey,
                            image: (_image == null)? null
                                : DecorationImage(
                                image: FileImage(_image),
                                fit: BoxFit.cover
                            )
                        ),
                        child: (_productFarmer.category == null)?
                        Icon(
                          Icons.photo,
                          color: color_white,
                        ).paddingAll(12): Container(),
                      ).paddingOnly(
                          top: spacing_control,
                          left: spacing_standard_new,
                          bottom: spacing_control)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Transform.scale(
                        scale: 0.9,
                        child: RoundedButton(
                            MyLocalizations.of(context).localization['categories'],
                            Icons.add_circle_outline,
                                () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return DialogPickProduct();
                                  }
                              ).then((value) {
                                if (value != null) {
                                  setState(() {
                                    _productFarmer.category = value;
                                  });
                                  getImage();
                                }
                              });
                            }
                        ),
                      ),
                      text(
                          (_productFarmer.category != null)? _productFarmer.category.name: '',
                          textColor: textColorPrimary,
                          fontSize: textSizeLarge,
                          fontFamily: fontMedium)
                          .paddingOnly(
                        left: spacing_standard,
                        right: spacing_standard,
                      )
                    ],
                  ),
                  SizedBox(
                    height: spacing_standard,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Transform.scale(
                        scale: 0.9,
                        child: RoundedButton(
                            MyLocalizations.of(context).localization['pick_location'],
                            Icons.location_on,
                                () {
                              showLocationPicker(
                                context, GOOGLE_MAP_API_KEY,
                                myLocationButtonEnabled: true,
                                layersButtonEnabled: true,
                              ).then((value) {

                                if (value != null) {
                                  _productFarmer.latitude = value.latLng.latitude;
                                  _productFarmer.longitude = value.latLng.longitude;
                                  Coordinates coordinates = new Coordinates(value.latLng.latitude, value.latLng.longitude);
                                  Geocoder.local.findAddressesFromCoordinates(coordinates).then((adresses) {
                                    if (adresses != null && adresses.length > 0) {
                                      if (adresses.first.locality != null) {
                                        setState(() {
                                          _productFarmer.city =
                                              adresses.first.locality;
                                        });
                                      }
                                    }
                                  });
                                }

                              });
                            }
                        ),
                      ),
                      text(
                          (_productFarmer != null)?
                          _productFarmer.city: '',
                          textColor: textColorPrimary,
                          fontSize: textSizeLarge,
                          fontFamily: fontMedium)
                          .paddingOnly(
                        left: spacing_standard,
                        right: spacing_standard,
                      )
                    ],
                  ),
                  SizedBox(
                    height: spacing_standard,
                  ),
                  EditText(
                    text: MyLocalizations.of(context).localization['product_name'],
                    fontSize: textSizeLargeMedium,
                    mController: _editingControllerProductName,
                    isPassword: false,
                  ).paddingAll(spacing_standard_new),
                  EditText(
                    text: MyLocalizations.of(context).localization['price'],
                    fontSize: textSizeLargeMedium,
                    keyboardType: TextInputType.number,
                    mController: _editingControllerPrice,
                    isPassword: false,
                  ).paddingAll(spacing_standard_new),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        height: spacing_standard_new,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      CustomButton(
                          textContent: MyLocalizations.of(context).localization['add'],
                          onPressed: () {
                            if (_productFarmer.category != null && _editingControllerPrice.text.isNotEmpty
                                && _editingControllerProductName.text.isNotEmpty) {
                              addProduct();
                            }
                          }
                      ).paddingOnly(
                          right: spacing_standard,
                          bottom: spacing_standard_new)
                    ],
                  )        ,
                ]
            ),
          ),
        )
      )
    );
  }

  Future addProduct() async {
    setState(() {
      isLoading = true;
    });
    if (_image != null) {
      _productFarmer.urlImage = await uploadFile(_image);
    }
    _productFarmer.name = _editingControllerProductName.text;
    _productFarmer.price = double.parse(_editingControllerPrice.text);
    _productFarmer.addProduct().then((value) {
      setState(() {
        isLoading = false;
      });
      if (value) {
        tst.Toast.show(MyLocalizations.of(context).localization['product_added'], context);
        Navigator.of(context).pop(_productFarmer);
      }
      else {
        tst.Toast.show(MyLocalizations.of(context).localization['error_occurred'], context);
      }
    });
  }

  Widget title1(var title, Color color1, Color textColor, BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(color: color1,),
        Center(
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.close,
                  size: 30,
                  color: textColor,
                ).paddingOnly(
                  top: spacing_standard_new,
                ),
                onPressed: () {
                  finish(context);
                },
              ),
              text(title, textColor: textColor, fontSize: textSizeNormal, fontFamily: fontBold, isCentered: true).paddingOnly(left: spacing_standard, top: 26)
            ],
          ).paddingOnly(left: spacing_standard, right: spacing_standard,),
        )
      ],
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

}