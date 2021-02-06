import 'package:cloud_firestore/cloud_firestore.dart';

class CityItem {

  static String COLLECTION_CITY = 'city';
  static String FIELD_NAME = 'name';

  String name = '';

  CityItem(this.name);

  Future<bool> addCity() async {
    try {
      if (! await isExist()) {
        DocumentReference documentReference = await FirebaseFirestore.instance
            .collection(COLLECTION_CITY).add({
          FIELD_NAME: name,
        });
      }
      return true;
    }
    catch(error) {
      return false;
    }
  }

  Future<bool> isExist() async {
    bool isExist = false;

    var document = await FirebaseFirestore.instance
        .collection(COLLECTION_CITY)
        .where(FIELD_NAME, isEqualTo: name)
        .limit(1).get();

    if (document != null && document.docs.length > 0) {
      isExist = true;
    }

    return isExist;
  }

  static Future<List<CityItem>> getCities() async {

    QuerySnapshot result;
    List<CityItem> cities = [];

    result = await FirebaseFirestore.instance
          .collection(COLLECTION_CITY).get();

    for (int i = 0; i < result.docs.length; i++) {
      Map<String, dynamic> data = result.docs[i].data();
      CityItem city = CityItem(data[FIELD_NAME]);
      cities.add(city);
    }

    return cities;
  }
}