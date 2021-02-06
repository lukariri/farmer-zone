import 'package:flutter_structure/models/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_structure/models/user.dart';

import 'city.dart';

class ProductFarmer {

  static String COLLECTION_PRODUCT_FARMER = 'product_farmer';

  static String FIELD_USER_ID = 'user_id';
  static String FIELD_PRODUCT_ID = 'product_id';
  static String FIELD_CITY = 'city';
  static String FIELD_PRICE = 'price';
  static String FIELD_LATITUDE = 'latitude';
  static String FIELD_LONGITUDE = 'longitude';
  static String FIELD_SALES = 'sales';
  static String FIELD_URL_IMAGE = 'image';
  static String FIELD_NAME = 'name';
  static String FIELD_CATEGORY_NAME = 'category_name';

  Category category;
  String productDocumentId, name = '';
  DocumentSnapshot productDocument;
  String city = '', userId, urlImage;
  UserItem userItem;
  int sales = 0;
  double price, latitude, longitude;

  static List<ProductFarmer> appCart = [];

  ProductFarmer(this.userId);

  Future<bool> addProduct() async {
    try {
      DocumentReference documentReference = await FirebaseFirestore.instance.collection(COLLECTION_PRODUCT_FARMER).add({
        FIELD_USER_ID: this.userId,
        FIELD_PRODUCT_ID: this.category.id,
        FIELD_CITY: this.city,
        FIELD_PRICE: this.price,
        FIELD_LATITUDE: this.latitude,
        FIELD_LONGITUDE: this.longitude,
        FIELD_SALES: 0,
        FIELD_URL_IMAGE: this.urlImage,
        FIELD_NAME: this.name,
        FIELD_CATEGORY_NAME: this.category.name
      });
      this.productDocumentId = documentReference.id;
      //add city to city collection
      CityItem cityItem = CityItem(this.city);
      cityItem.addCity();
      return true;
    }
    catch(error) {
      return false;
    }
  }

  static Future<List<ProductFarmer>> getLatestProducts(int length, {lastProductDoc}) async {

    QuerySnapshot result;
    List<ProductFarmer> products = [];

    if (lastProductDoc != null) {
      result = await FirebaseFirestore.instance
          .collection(COLLECTION_PRODUCT_FARMER)
          .startAfterDocument(lastProductDoc).limit(length).get();
    }
    else {
      result = await FirebaseFirestore.instance
          .collection(COLLECTION_PRODUCT_FARMER).limit(length).get();
    }

    for (int i = 0; i < result.docs.length; i++) {
      Map<String, dynamic> data = result.docs[i].data();
      ProductFarmer product = await ProductFarmer.getFromMap(data, document: result.docs[i]);

      products.add(product);
    }

    return products;
  }

  static Future<List<ProductFarmer>> getFarmerProducts(String userId, int length, {lastProductDoc}) async {

    QuerySnapshot result;
    List<ProductFarmer> products = [];

    if (lastProductDoc != null) {
      result = await FirebaseFirestore.instance
          .collection(COLLECTION_PRODUCT_FARMER)
          .where(FIELD_USER_ID, isEqualTo: userId)
          .startAfterDocument(lastProductDoc).limit(length).get();
    }
    else {
      result = await FirebaseFirestore.instance
          .collection(COLLECTION_PRODUCT_FARMER)
          .where(FIELD_USER_ID, isEqualTo: userId).limit(length).get();
    }

    for (int i = 0; i < result.docs.length; i++) {
      Map<String, dynamic> data = result.docs[i].data();
      ProductFarmer product = await ProductFarmer.getFromMap(data, document: result.docs[i]);

      products.add(product);
    }

    return products;
  }

  static Future<List<ProductFarmer>> getAllFarmerProducts() async {

    QuerySnapshot result;
    List<ProductFarmer> products = [];

    result = await FirebaseFirestore.instance
          .collection(COLLECTION_PRODUCT_FARMER).get();

    for (int i = 0; i < result.docs.length; i++) {
      Map<String, dynamic> data = result.docs[i].data();
      ProductFarmer product = await ProductFarmer.getFromMap(data, document: result.docs[i]);

      products.add(product);
    }

    return products;
  }

  //get products by city or by product type
  static Future<List<ProductFarmer>> filterProducts(String city, String cetegoryId, int length, {lastProductDoc}) async {

    QuerySnapshot result;
    List<ProductFarmer> products = [];

    Query query = FirebaseFirestore.instance.collection(COLLECTION_PRODUCT_FARMER);

    if (city != '0') {
      query = query.where(FIELD_CITY, isEqualTo: city);
    }
    if (cetegoryId != '-1') {
      query = query.where(FIELD_PRODUCT_ID, isEqualTo: cetegoryId);
    }
    if (lastProductDoc != null) {
      query = query.startAfterDocument(lastProductDoc);
    }

    result = await query.limit(length).get();

    for (int i = 0; i < result.docs.length; i++) {
      Map<String, dynamic> data = result.docs[i].data();
      ProductFarmer product = await ProductFarmer.getFromMap(data, document: result.docs[i]);

      products.add(product);
    }

    return products;
  }

  //get a product from his id
  static Future<ProductFarmer> getFarmerProduct(String productId) async {

    DocumentSnapshot result = await FirebaseFirestore.instance
          .collection(COLLECTION_PRODUCT_FARMER).doc(productId).get();

    Map<String, dynamic> data = result.data();
    ProductFarmer product = await ProductFarmer.getFromMap(data, document: result);

    return product;
  }

  Future<bool> updateSales() async {
    try {
      await FirebaseFirestore.instance.collection(COLLECTION_PRODUCT_FARMER)
          .doc(this.productDocumentId)
          .update({
        FIELD_SALES: this.sales,
      });
    }
    catch (error) {
      return false;
    }
  }

  static Future<ProductFarmer> getFromMap(Map data, {document}) async {

    ProductFarmer product = new ProductFarmer(data[FIELD_USER_ID]);

    product.userItem = await UserItem.getUser(data[FIELD_USER_ID]);

    if (data[FIELD_PRODUCT_ID] == '0') { //other category
      product.category = Category.otherCategory;
    }
    else {
      product.category = Category.allCategories[data[FIELD_PRODUCT_ID]];
    }

    product.productDocumentId = document.id?? '';
    product.productDocument = document;
    product.price = data[FIELD_PRICE];
    product.longitude = data[FIELD_LONGITUDE];
    product.latitude = data[FIELD_LATITUDE];
    product.city = data[FIELD_CITY];
    product.userId = data[FIELD_USER_ID];
    product.sales = data[FIELD_SALES]?? 0;
    product.urlImage = data[FIELD_URL_IMAGE];
    product.name = data[FIELD_NAME];

    //if there is not specific image for that product, get the default one
    if (product.urlImage == null || product.urlImage.length == 0) {
      product.urlImage = product.category.urlImage;
    }

    //if name doesn't exist get it from category name
    if (product.name == null || product.name.isEmpty) {
      product.name = product.category.name;
    }

    return product;

  }

}