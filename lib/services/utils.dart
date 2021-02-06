import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'localizations.dart';
import 'package:image/image.dart' as IMG;

const LANG_CODE = 'en';

List<String> languages = ['en'];

Uint8List resizeImage(Uint8List data, int width, int height) {
  Uint8List resizedData = data;
  IMG.Image img = IMG.decodeImage(data);
  IMG.Image resized = IMG.copyResize(img, width: width, height: height);
  resizedData = IMG.encodeJpg(resized);
  return resizedData;
}

Future<String> uploadFile(File fileToUpload, {fileName: ''}) async {
  if (fileToUpload != null) {
    if (fileName.length == 0) {
      fileName = DateTime
          .now()
          .millisecondsSinceEpoch
          .toString();
    }
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(fileToUpload);
    StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;
    var downloadUrl = await storageSnapshot.ref.getDownloadURL();
    if (uploadTask.isComplete) {
      return downloadUrl.toString();
    }
  }
  return '';
}