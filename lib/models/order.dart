import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_structure/models/product_farmer.dart';

class Order {

  String id = '', userId = '';
  DateTime dateTime;
  DocumentSnapshot documentSnapshot;

  static String COLLECTION_ORDER = 'product_order';
  static String FIELD_USER_ID = 'user_id';
  static String FIELD_DATE = 'register_date';

  static String COLLECTION_ORDER_DETAILS = 'order_details';
  static String FIELD_ORDER_ID = 'order_id';
  static String FIELD_PRODUCT_ID = 'product_id';

  Future<bool> addOrder(List<ProductFarmer> products) async {
    try {
      DocumentReference documentReference = await FirebaseFirestore.instance.collection(COLLECTION_ORDER).add({
        FIELD_USER_ID: this.userId,
        FIELD_DATE: this.dateTime.millisecondsSinceEpoch
      });
      this.id = documentReference.id;
      //add products details related to order
      products.forEach((element) {
        element.sales += 1;
        element.updateSales();
        this.addOrderDetails(element.userId, element.productDocumentId);
      });
      return true;
    }
    catch(error) {
      return false;
    }
  }

  Future<bool> addOrderDetails(String userId, String productId) async {
    try {
      DocumentReference documentReference = await FirebaseFirestore.instance.collection(COLLECTION_ORDER_DETAILS).add({
        FIELD_ORDER_ID: this.id,
        FIELD_PRODUCT_ID: productId,
        FIELD_USER_ID: userId
      });
      return true;
    }
    catch(error) {
      return false;
    }
  }

  static Future<List<Order>> getLatestOrders(String userId, int length, {lastOrderDoc}) async {

    QuerySnapshot result;
    List<Order> orders = [];

    if (lastOrderDoc != null) {
      result = await FirebaseFirestore.instance
          .collection(COLLECTION_ORDER)
          .where(FIELD_USER_ID, isEqualTo: userId)
          .orderBy(FIELD_DATE, descending: true)
          .startAfterDocument(lastOrderDoc).limit(length).get();
    }
    else {
      result = await FirebaseFirestore.instance
          .collection(COLLECTION_ORDER)
          .where(FIELD_USER_ID, isEqualTo: userId)
          .orderBy(FIELD_DATE, descending: true).limit(length).get();
    }

    for (int i = 0; i < result.docs.length; i++) {
      Map<String, dynamic> data = result.docs[i].data();
      Order order = Order();
      order.id = result.docs[i].id;
      order.documentSnapshot = result.docs[i];
      order.documentSnapshot = result.docs[i];
      order.userId = data[FIELD_USER_ID];
      order.dateTime = DateTime.fromMillisecondsSinceEpoch(data[FIELD_DATE]);

      orders.add(order);
    }

    return orders;
  }

  static Future<List<ProductFarmer>> getOrderProducts(String orderId, int length, {lastProductDoc}) async {

    QuerySnapshot result;
    List<ProductFarmer> products = [];

    if (lastProductDoc != null) {
      result = await FirebaseFirestore.instance
          .collection(COLLECTION_ORDER_DETAILS)
          .where(FIELD_ORDER_ID, isEqualTo: orderId)
          .startAfterDocument(lastProductDoc).limit(length).get();
    }
    else {
      result = await FirebaseFirestore.instance
          .collection(COLLECTION_ORDER_DETAILS)
          .where(FIELD_ORDER_ID, isEqualTo: orderId).limit(length).get();
    }

    for (int i = 0; i < result.docs.length; i++) {
      Map<String, dynamic> data = result.docs[i].data();
      ProductFarmer productFarmer = await ProductFarmer.getFarmerProduct(data[FIELD_PRODUCT_ID]);
      products.add(productFarmer);
    }

    return products;
  }

}