import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserItem {

  static int ACCOUNT_TYPE_SIMPLE = 0;
  static int ACCOUNT_TYPE_FARMER = 1;

  static String COLLECTION_USERS = 'users_data';
  static String FIELD_ACCOUNT_TYPE = 'account_type';
  static String FIELD_USER_ID = 'user_id';
  static String FIELD_FULL_NAME = 'full_name';
  static String FIELD_EMAIL = 'email';

  String email, fullName;
  String userId;
  int accountType;

  static UserItem currentUser;

  UserItem(this.userId, this.email, this.fullName, {this.accountType: 0});

  Future saveUser() async {
    String map = """{
      "id": "${this.userId}",
      "email": "${this.email}",
      "full_name": "${this.fullName}",
      "account_type": ${this.accountType}
    }""";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('user', map);
  }

  static Future<UserItem> getInstance() async {
    if(currentUser == null) {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String userString = sharedPreferences.getString('user');
      if(userString != null) {
        Map userMap = json.decode(userString);
        currentUser = new UserItem(
            userMap['id'],
            userMap['email'],
            userMap['full_name'],
            accountType: userMap['account_type']
        );
      }
    }
    return currentUser;
  }

  //add other fields that firebase doesn't initialy have
  Future addUserAdditionalFields() async {
    CollectionReference users = FirebaseFirestore.instance.collection(COLLECTION_USERS);
    await users.add(
      {
        FIELD_USER_ID: this.userId,
        FIELD_ACCOUNT_TYPE: this.accountType,
        FIELD_FULL_NAME: this.fullName,
        FIELD_EMAIL: this.email
      }
    );
  }

  Future getAdditionalFields() async {

    var document = await FirebaseFirestore.instance
        .collection(COLLECTION_USERS)
        .where(FIELD_USER_ID, isEqualTo: this.userId)
        .limit(1).get();
    if (document != null && document.docs.length > 0) {
      document.docs.forEach((document) {
        Map<String, dynamic> data = document.data();
        this.accountType = data[FIELD_ACCOUNT_TYPE];
        this.fullName = data[FIELD_FULL_NAME];
        this.email = data[FIELD_EMAIL];
      });
    }

  }

  //get user by id
  static Future<UserItem> getUser(String userId) async {
    UserItem userItem = UserItem(userId, '', '');

    var document = await FirebaseFirestore.instance
        .collection(COLLECTION_USERS)
        .where(FIELD_USER_ID, isEqualTo: userId)
        .limit(1).get();
    if (document != null && document.docs.length > 0) {
      document.docs.forEach((document) {
        Map<String, dynamic> data = document.data();
        userItem.accountType = data[FIELD_ACCOUNT_TYPE];
        userItem.email = data[FIELD_EMAIL];
        userItem.fullName = data[FIELD_FULL_NAME];
      });
    }

    return userItem;
  }

}