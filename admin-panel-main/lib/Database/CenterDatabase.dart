import 'package:admin/Database/RequextDatabase.dart';
import 'package:admin/Database/UserDatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
// import 'package:geolocator/geolocator.dart';

class CenterData {
  static final CollectionReference centerDataCollection =
      FirebaseFirestore.instance.collection('bloodDonationCenters');

  static Future<void> createBloodDonationCenter({
    @required name,
    @required emailId,
    @required mobileNumber,
    @required address,
    @required contactName,
    @required latitude,
    @required longitude,
  }) async {
    await centerDataCollection.doc(name).set({
      'name': name,
      'emailId': emailId,
      'mobileNumber': mobileNumber,
      'address': address,
      'location': new GeoPoint(latitude, longitude),
      'adminUsers': [],
      'contactName': contactName,
    });
    await centerDataCollection.doc('index').update({
      'center_location.$name': new GeoPoint(latitude, longitude),
      'centers.$name': address,
    });
  }

  static Future<bool> updateLocationDonationCenter({
    @required name,
    @required latitude,
    @required longitude,
  }) async {
    await centerDataCollection.doc(name).update({
      'location': new GeoPoint(latitude, longitude),
    });
    await centerDataCollection.doc('index').update({
      'center_location.$name': new GeoPoint(latitude, longitude),
    });

    DocumentSnapshot data =
        await RequestData.bloodRequestCollection.doc('requestView').get();
    Map requestData = data.data();
    Map requests = requestData['allRequests'];

    GeoPoint newLocation = new GeoPoint(latitude, longitude);

    requests.forEach((key, value) async {
      String centerName = key.toString().split("_")[0];
      String bloodType = key.toString().split("_")[1];
      if (name == centerName) {
        print(name);
        DocumentSnapshot bloodTypeRequestData =
            await RequestData.bloodRequestCollection.doc(bloodType).get();
        Map bloodTypeRequest = bloodTypeRequestData.data();
        Map requestInfo = bloodTypeRequest['requests'];
        List info = requestInfo[name];
        await RequestData.bloodRequestCollection.doc(bloodType).update({
          'requests.$name': [
            newLocation,
            info[1],
            info[2],
            info[3],
          ],
        });
      }
    });
    return true;
  }

  static Future<bool> updateBloodDonationCenter({
    @required name,
    @required emailId,
    @required mobileNumber,
    @required address,
    @required contactName,
  }) async {
    await centerDataCollection.doc(name).update({
      'emailId': emailId,
      'mobileNumber': mobileNumber,
      'address': address,
      'contactName': contactName,
    });
    await centerDataCollection.doc('index').update({
      'centers.$name': address,
    });
    return true;
  }

  //TODO: try this function

  static Future<bool> deleteBloodDonationCenter({
    name,
  }) async {
    await centerDataCollection.doc('index').update({
      'center_location.$name': FieldValue.delete(),
      'centers.$name': FieldValue.delete(),
    });

    DocumentSnapshot data = await centerDataCollection.doc(name).get();
    Map<String, dynamic> centerData = data.data();
    List adminList = centerData['adminUsers'];

    DocumentSnapshot centerIndexData =
        await centerDataCollection.doc('index').get();
    Map<String, dynamic> centerIndex = centerIndexData.data();
    Map centerList = centerIndex['center_location'];

    if (adminList != null || adminList.isEmpty != true) {
      adminList.forEach((docId) async {
        await UserDatabase.userDataCollection.doc(docId).update({
          'centerName': centerList.keys.elementAt(0),
        });

        DocumentSnapshot data =
            await UserDatabase.userDataCollection.doc(docId).get();
        Map<String, dynamic> userData = data.data();

        String emailId = userData['emailId'];
        String firstName = userData['firstName'];
        String lastName = userData['lastName'];
        String mobileNumber = userData['mobileNumber'];

        await UserDatabase.adminUserView.doc('adminIndex').update({
          'users': FieldValue.arrayRemove([
            {
              'centerName': name,
              'docId': docId,
              'emailId': emailId,
              'firstName': firstName,
              'lastName': lastName,
              'mobileNumber': mobileNumber,
              'authLevel': userData['authLevel'],
            }
          ]),
        });

        await UserDatabase.adminUserView.doc('adminIndex').update({
          'users': FieldValue.arrayUnion([
            {
              'centerName': centerList.keys.elementAt(0),
              'docId': docId,
              'emailId': emailId,
              'firstName': firstName,
              'lastName': lastName,
              'mobileNumber': mobileNumber,
              'authLevel': userData['authLevel'],
            }
          ]),
        });

        await CenterData.centerDataCollection
            .doc(centerList.keys.elementAt(0))
            .update({
          'adminUsers': FieldValue.arrayUnion([
            docId,
          ]),
        });
      });
    }

    await centerDataCollection.doc(name).delete();
    return true;
  }
}

// static Future<DocumentSnapshot> getNearestCenter({
//   @required latitude,
//   @required longitude,
// }) async {
//   DocumentSnapshot document =
//       await CenterData.centerDataCollection.doc('index').get();
//   Map data = document.data();
//   Map locations = data['center_location'];
//   int smallestD;
//   String name;
//   int distance;
//   locations.forEach((key, value) {
//     if (value != null) {
//       distance = Geolocator.distanceBetween(
//               latitude, longitude, value.latitude, value.longitude)
//           .toInt();
//       if (smallestD == null || distance < smallestD) {
//         smallestD = distance;
//         name = key;
//       }
//     }
//   });
//   return await CenterData.centerDataCollection.doc(name).get();
// }
//
// static Future<DocumentSnapshot> getNearestCenterWithDocument({
//   @required latitude,
//   @required longitude,
//   @required index,
// }) async {
//   Map locations = index['center_location'];
//   int smallestD;
//   String name;
//   int distance;
//   locations.forEach((key, value) {
//     if (value != null) {
//       distance = Geolocator.distanceBetween(
//               latitude, longitude, value.latitude, value.longitude)
//           .toInt();
//       if (smallestD == null || distance < smallestD) {
//         smallestD = distance;
//         name = key;
//       }
//     }
//   });
//   return await CenterData.centerDataCollection.doc(name).get();
// }
