import 'package:flutter/material.dart';
import 'package:flutter_structure/components/custom_button.dart';
import 'package:flutter_structure/components/product_widget.dart';
import 'package:flutter_structure/components/widgets.dart';
import 'package:flutter_structure/models/city.dart';
import 'package:flutter_structure/models/category.dart';
import 'package:flutter_structure/models/product_farmer.dart';
import 'package:flutter_structure/services/constants.dart';
import 'package:flutter_structure/services/localizations.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FragmentSearch extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _FragmentSearchState();
  }

}

class _FragmentSearchState extends State<FragmentSearch> {

  List<ProductFarmer> products = [];
  List<CityItem> cities = [];
  RefreshController _refreshController = RefreshController();
  bool isLoading = true;
  String selectedCategory = '-1', selectedCity = '0';
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    CityItem.getCities().then((value) {
      setState(() {
        cities = value;
      });
    });
    Category.categoriesIds.forEach((element) {
      categories.add(Category.allCategories[element]);
    });
    categories.add(Category.otherCategory);
    initProducts();
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  initProducts() {
    products.clear();
    setState(() {
      isLoading = true;
    });
    ProductFarmer.filterProducts(selectedCity, selectedCategory, 10).then((value) {
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
      ProductFarmer.filterProducts(selectedCity, selectedCategory, 10, lastProductDoc: products.last.productDocument).then((value) {
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
    return Column(
      children: [
        SizedBox(height: 10.0,),
        Column(
          children: [
            Container(
              child: Row(
                children: [
                  Text(
                    MyLocalizations.of(context).localization['category'],
                    style: TextStyle(),
                  )
                ],
              ),
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.04,
              child: ListView.builder(
                  itemCount: categories.length + 1,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {

                    if (index == 0) {
                      return Container(
                        child: InkWell(
                          child: Chip(
                            label: Text(
                              MyLocalizations.of(context).localization['all'],
                              style: TextStyle(
                                  color: (selectedCategory == '-1')?
                                  color_white: Colors.black
                              ),
                            ),
                            backgroundColor: (selectedCategory == '-1')?
                            colorPrimary: light_gray_color,
                          ),
                          onTap: () {
                            setState(() {
                              selectedCategory = '-1';
                            });
                            initProducts();
                          },
                        ),
                        margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      );
                    }
                    else {
                      return Container(
                        child: InkWell(
                          child: Chip(
                            label: Text(
                              categories[index-1].name,
                              style: TextStyle(
                                  color: (selectedCategory == categories[index-1].id)?
                                  color_white: Colors.black
                              ),
                            ),
                            backgroundColor: (selectedCategory == categories[index-1].id)?
                            colorPrimary: light_gray_color,
                          ),
                          onTap: () {
                            setState(() {
                              selectedCategory = categories[index-1].id;
                            });
                            initProducts();
                          },
                        ),
                        margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      );
                    }
                  }
              ),
            )
          ],
        ),
        SizedBox(height: 10.0,),
        Column(
          children: [
            Container(
              child: Row(
                children: [
                  Text(
                    MyLocalizations.of(context).localization['city'],
                    style: TextStyle(),
                  )
                ],
              ),
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.04,
              child: ListView.builder(
                  itemCount: cities.length + 1,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {

                    if (index == 0) {
                      return Container(
                        child: InkWell(
                          child: Chip(
                            label: Text(
                              MyLocalizations.of(context).localization['all'],
                              style: TextStyle(
                                  color: (selectedCity == '0')?
                                  color_white: Colors.black
                              ),
                            ),
                            backgroundColor: (selectedCity == '0')?
                            colorPrimary: light_gray_color,
                          ),
                          onTap: () {
                            setState(() {
                              selectedCity = '0';
                            });
                            initProducts();
                          },
                        ),
                        margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      );
                    }
                    else {
                      return Container(
                        child: InkWell(
                          child: Chip(
                            label: Text(
                              cities[index-1].name,
                              style: TextStyle(
                                  color: (selectedCity == cities[index-1].name)?
                                  color_white: Colors.black
                              ),
                            ),
                            backgroundColor: (selectedCity == cities[index-1].name)?
                            colorPrimary: light_gray_color,
                          ),
                          onTap: () {
                            setState(() {
                              selectedCity = cities[index-1].name;
                            });
                            initProducts();
                          },
                        ),
                        margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      );
                    }
                  }
              ),
            )
          ],
        ),
        Expanded(
            child: (isLoading)?
            Center(
                child: CircularProgressIndicator()
            ):
            SmartRefresher(
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
              enablePullDown: false,
              enablePullUp: true,
              onLoading: loadProducts,
              child: ListView.builder(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductWidget(products[index]);
                },
              ),
            )
        )
      ],
    );
  }

}