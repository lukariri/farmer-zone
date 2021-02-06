import 'package:flutter/material.dart';
import 'package:flutter_structure/components/custom_button.dart';
import 'package:flutter_structure/components/product_widget.dart';
import 'package:flutter_structure/components/widgets.dart';
import 'package:flutter_structure/models/product_farmer.dart';
import 'package:flutter_structure/services/constants.dart';
import 'package:flutter_structure/services/localizations.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FragmentHome extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _FragmentHomeState();
  }

}

class _FragmentHomeState extends State<FragmentHome> {

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
    ProductFarmer.getLatestProducts(10).then((value) {
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

  loadProducts() {
    if (products.length > 0) {
      ProductFarmer.getLatestProducts(10, lastProductDoc: products.last.productDocument).then((value) {
        _onCompleteProductAddition(value);
      });
    }
    else {
      _refreshController.loadComplete();
    }
  }

  _onCompleteProductAddition(List<ProductFarmer> productList) {
    setState(() {
      products.addAll(productList);
    });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        controller: _refreshController,
        header: WaterDropMaterialHeader(
          backgroundColor: Theme.of(context).primaryColor,
        ),
        footer: CustomFooter(
          builder: (BuildContext context,LoadStatus mode){
            Widget body ;
            if(mode==LoadStatus.loading){
              body =  CircularProgressIndicator();
            }
            else{
              body = Container();
            }
            return Container(
              height: 55.0,
              child: Center(child:body),
            );
          },
        ),
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: initProducts,
        onLoading: loadProducts,
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
    );
  }

}