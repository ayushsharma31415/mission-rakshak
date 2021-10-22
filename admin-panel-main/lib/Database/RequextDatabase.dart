import 'package:admin/Database/CenterDatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequestData {
  static final CollectionReference bloodRequestCollection =
      FirebaseFirestore.instance.collection('bloodRequests');

  static Future<bool> createBloodDonationRequest({
    @required name,
    @required priorityLevel,
    @required bloodType,
  }) async {
    DocumentSnapshot data =
        await CenterData.centerDataCollection.doc(name).get();
    Map centerData = data.data();
    String address = centerData['address'];
    GeoPoint geoPoint = centerData['location'];

    await bloodRequestCollection.doc(bloodType).update({
      'requests.$name': [geoPoint, address, name, priorityLevel],
    });

    List requestData = [name, bloodType, Timestamp.now(), priorityLevel];
    await bloodRequestCollection.doc('requestView').update({
      'allRequests.${name}_$bloodType': requestData,
    });
    return true;
  }

  static Future<bool> deleteBloodDonationRequest({
    @required name,
    @required bloodType,
  }) async {
    await bloodRequestCollection.doc(bloodType).update({
      'requests.$name': FieldValue.delete(),
    });

    await bloodRequestCollection.doc('requestView').update({
      'allRequests.${name}_$bloodType': FieldValue.delete(),
    });
    return true;
  }

  // static Future<DocumentSnapshot> getNearestRequest({
  //   @required latitude,
  //   @required longitude,
  //   @required bloodType,
  // }) async {
  //   print(bloodType);
  //   DocumentSnapshot document =
  //   await RequestData.bloodRequestCollection.doc(bloodType).get();
  //   Map data = document.data();
  //   Map requests = data['requests'];
  //   print(requests);
  //   String keyVal;
  //   if (requests.length == 0) {
  //     return await CenterData.centerDataCollection
  //         .doc('thisWillNotExistCuzWhatsTheProbablity')
  //         .get();
  //   }
  //   if (requests.length == 1) {
  //     requests.forEach((key, value) async {
  //       keyVal = key.toString();
  //     });
  //     return await CenterData.centerDataCollection.doc(keyVal).get();
  //   } else {
  //     int smallestD;
  //     String name;
  //     int distance;
  //     requests.forEach((key, value) {
  //       if (value != null) {
  //         distance = Geolocator.distanceBetween(
  //             latitude, longitude, value[0].latitude, value[0].longitude)
  //             .toInt();
  //         if (smallestD == null || distance < smallestD) {
  //           smallestD = distance;
  //           name = key.toString();
  //         }
  //       }
  //     });
  //     return await CenterData.centerDataCollection.doc(name).get();
  //   }
  // }
}
