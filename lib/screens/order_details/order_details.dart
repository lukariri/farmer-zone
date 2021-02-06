import 'package:flutter/material.dart';
import 'package:flutter_structure/components/custom_button.dart';
import 'package:flutter_structure/components/product_widget.dart';
import 'package:flutter_structure/components/widgets.dart';
import 'package:flutter_structure/models/order.dart';
import 'package:flutter_structure/models/product_farmer.dart';
import 'package:flutter_structure/models/user.dart';
import 'package:flutter_structure/screens/add_product/add_product.dart';
import 'package:flutter_structure/services/constants.dart';
import 'package:flutter_structure/services/localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OrderDetails extends StatefulWidget {

  String orderId = '';

  OrderDetails(this.orderId);

  @override
  State<StatefulWidget> createState() {
    return _OrderDetailsState();
  }

}

class _OrderDetailsState extends State<OrderDetails> {

  List<ProductFarmer> products = [];
  RefreshController _refreshController = RefreshController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initProducts();
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  initProducts() {
    setState(() {
      isLoading = true;
    });
    Order.getOrderProducts(widget.orderId, 10).then((value) {
      _completeProductsInitialization(value);
    });
  }

  _completeProductsInitialization(List<ProductFarmer> productsList) {
    setState(() {
      products = productsList;
      isLoading = false;
    });
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_background,
      appBar: AppBar(
        backgroundColor: colorPrimary,
        title: Text(
          MyLocalizations.of(context).localization['order_details']
        ),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        header: WaterDropMaterialHeader(
          backgroundColor: Theme.of(context).primaryColor,
        ),
        enablePullDown: true,
        enablePullUp: false,
        onRefresh: initProducts,
        child: (isLoading)?
        Center(
            child: CircularProgressIndicator()
        ):
        ListView.builder(
          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ProductWidget(products[index]);
          },
        ),
      ),
    );
  }

}