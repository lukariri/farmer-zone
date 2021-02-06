import 'package:flutter_structure/models/city.dart';
import 'package:flutter_structure/models/category.dart';
import 'package:flutter_structure/models/product_farmer.dart';

//this class help to get stats of products sales by town
class CitySales {

  String city;
  int sales;
  Category category;
  double latitude, longitude;

  static Future<List<CitySales>> getAllSales() async {
    List<CitySales> sales = [];

    List<ProductFarmer> productsList = await ProductFarmer.getAllFarmerProducts();
    List<CityItem> cityList = await CityItem.getCities();

    cityList.forEach((city) {
      //filter all farmer products by city
      List<ProductFarmer> cityProducts = productsList.where((element) {
        return element.city == city.name;
      }).toList();

      /**
       * Here it is about a system which makes it possible to calculate the number
       * of sales by product and by city, productIds makes it possible to store
       * the ids of the different products so as not to duplicate them and
       * mapCityProducts will store for each product id an object of the CitySales type which owns sales info; after having retrieved its values, they will be stored in a list of 'CitySales'
       */
      List<String> productsId = [];
      Map<String, CitySales> mapCityProducts = {};

      cityProducts.forEach((element) {
        if (! productsId.contains(element.category.id)) {
          productsId.add(element.category.id);

          if (element.latitude != null && element.longitude != null) {

            CitySales sales = CitySales();
            sales.city = city.name;
            sales.category = element.category;
            sales.sales = element.sales;
            sales.latitude = element.latitude;
            sales.longitude = element.longitude;
            mapCityProducts[element.category.id] = sales;

          }
        }
        else {
          mapCityProducts[element.category.id].sales += element.sales;
        }
      });

      //add all values on sales list
      productsId.forEach((id) {
        sales.add(mapCityProducts[id]);
      });

     });

    return sales;
  }
}