import 'package:admin/Database/CenterDatabase.dart';
import 'package:admin/Database/Counter.dart';
import 'package:admin/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserDatabase {
  User user;

  UserDatabase(this.user);

  // collection reference
  static final CollectionReference userDataCollection =
      FirebaseFirestore.instance.collection('UserData');

  static final CollectionReference verifiedUserViewCollection =
      FirebaseFirestore.instance.collection('verifiedUserView');

  static final CollectionReference nonVerifiedUserViewCollection =
      FirebaseFirestore.instance.collection('nonVerifiedUserView');

  static final CollectionReference adminUserView =
      FirebaseFirestore.instance.collection('AdminView');

  Future<void> createUnauthorizedUser() async {
    return await userDataCollection.doc(user.uid).set({
      'correctData': false,
      'firstName': '',
      'lastName': '',
      'emailId': user.email,
      'mobileNumber': '',
      'bloodType': '',
      'DOB': '',
      'gender': '',
      'donatedBefore': false,
      'authorized': false,
      'address': '',
      'location': null,
    });
  }

  Future<void> updateUnauthorizedUserDataFromSignIn({
    @required firstName,
    @required lastName,
    @required mobileNumber,
    @required bloodType,
    @required gender,
    @required DOB,
    @required address,
    @required latitude,
    @required longitude,
  }) async {
    await userDataCollection.doc(user.uid).update({
      'correctData': true,
      'firstName': firstName,
      'lastName': lastName,
      'emailId': user.email,
      'mobileNumber': mobileNumber,
      'bloodType': bloodType,
      'DOB': DOB,
      'gender': gender,
      'address': address,
      'location': new GeoPoint(latitude, longitude),
      // 'donatedBefore': false,
    });

    await nonVerifiedUserViewCollection.doc(bloodType).update({
      'users': FieldValue.arrayUnion([
        {
          'firstName': firstName,
          'lastName': lastName,
          'emailId': user.email,
          'mobileNumber': mobileNumber,
          'DOB': DOB,
          'docId': user.uid,
        }
      ])
    });

    await Counter.addUnverifiedUser();

    return true;
  }

  static Future<bool> updateUnauthorizedUserDataFromProfilePage({
    @required firstName,
    @required lastName,
    @required mobileNumber,
    @required address,
    @required oldFirstName,
    @required oldLastName,
    @required oldMobileNumber,
    @required DOB,
    @required bloodType,
    @required docId,
    @required emailId,
  }) async {
    await nonVerifiedUserViewCollection.doc(bloodType).update({
      'users': FieldValue.arrayRemove([
        {
          'firstName': oldFirstName,
          'lastName': oldLastName,
          'emailId': emailId,
          'mobileNumber': oldMobileNumber,
          'DOB': DOB,
          'docId': docId,
        }
      ]),
    });

    await nonVerifiedUserViewCollection.doc(bloodType).update({
      'users': FieldValue.arrayUnion([
        {
          'firstName': firstName,
          'lastName': lastName,
          'emailId': emailId,
          'mobileNumber': mobileNumber,
          'DOB': DOB,
          'docId': docId,
        }
      ]),
    });

    await userDataCollection.doc(docId).update({
      // 'correctData': true,
      'firstName': firstName,
      'lastName': lastName,
      // 'emailId': user.email,
      'mobileNumber': mobileNumber,
      // 'bloodType': bloodType,
      // 'DOB': null,
      // 'gender': gender,
      'address': address,
      // 'donatedBefore': false,
      // 'location': new GeoPoint(latitude, longitude),
    });
    return true;
  }

  // VERIFIED USERS

  static Future<bool> updateVerifiedUserDataFromProfilePage({
    @required mobileNumber,
    @required oldMobileNumber,
    @required address,
    @required firstName,
    @required lastName,
    @required oldFirstName,
    @required oldLastName,
    @required DOB,
    @required docId,
    @required emailId,
    @required bloodType,
  }) async {
    await verifiedUserViewCollection
        .doc(bloodType)
        .collection('verifiedView')
        .doc(docId)
        .update({
      'firstName': firstName,
      'lastName': lastName,
      'mobileNumber': mobileNumber,
    });

    // await verifiedUserViewCollection.doc(bloodType).update({
    //   'users': FieldValue.arrayRemove([
    //     {
    //       'firstName': oldFirstName,
    //       'lastName': oldLastName,
    //       'emailId': emailId,
    //       'mobileNumber': oldMobileNumber,
    //       'DOB': DOB,
    //       'docId': docId,
    //     }
    //   ]),
    // });
    //
    // await verifiedUserViewCollection.doc(bloodType).update({
    //   'users': FieldValue.arrayUnion([
    //     {
    //       'firstName': firstName,
    //       'lastName': lastName,
    //       'emailId': emailId,
    //       'mobileNumber': mobileNumber,
    //       'DOB': DOB,
    //       'docId': docId,
    //     }
    //   ]),
    // });

    await userDataCollection.doc(docId).update({
      // 'correctData': true,
      'firstName': firstName,
      'lastName': lastName,
      // 'emailId': user.email,
      'mobileNumber': mobileNumber,
      // 'bloodType': bloodType,
      // 'DOB': null,
      // 'gender': gender,
      'address': address,
      // 'donatedBefore': false,
      // 'location': new GeoPoint(latitude, longitude),
    });

    return true;
  }

  static Future<bool> makeUserVerified({
    @required firstName,
    @required lastName,
    @required mobileNumber,
    @required DOB,
    @required bloodType,
    @required uid,
    @required email,
  }) async {
    await nonVerifiedUserViewCollection.doc(bloodType).update({
      'users': FieldValue.arrayRemove([
        {
          'firstName': firstName,
          'lastName': lastName,
          'emailId': email,
          'mobileNumber': mobileNumber,
          'DOB': DOB,
          'docId': uid,
        }
      ]),
    });

    await verifiedUserViewCollection
        .doc(bloodType)
        .collection('verifiedView')
        .doc(uid)
        .set({
      'firstName': firstName,
      'lastName': lastName,
      'emailId': email,
      'mobileNumber': mobileNumber,
      'DOB': DOB,
      'docId': uid,
      'donations': 0,
    });

    await userDataCollection.doc(uid).update({
      'donatedBefore': true,
      'donations': 0,
    });

    await Counter.convertToVerifiedUser(bloodType);

    return true;
  }

  //AUTHORIZED USERS--------------------------------------------------------

  Future<void> createAuthorizedUser() async {
    return await userDataCollection.doc(user.uid).set({
      'correctData': false,
      'firstName': '',
      'lastName': '',
      'emailId': user.email,
      'mobileNumber': '',
      'authorized': true,
      'centerName': '',
      'authLevel': 2,
    });
  }

  Future<void> updateAuthorizedUserDataFromSignIn(
      {@required firstName,
      @required lastName,
      @required mobileNumber,
      @required centerName}) async {
    await userDataCollection.doc(user.uid).update({
      'correctData': true,
      'firstName': firstName,
      'lastName': lastName,
      'emailId': user.email,
      'mobileNumber': mobileNumber,
      'authorized': true,
      'centerName': centerName,
    });

    await adminUserView.doc('adminIndex').update({
      'users': FieldValue.arrayUnion([
        {
          'firstName': firstName,
          'lastName': lastName,
          'emailId': user.email,
          'mobileNumber': mobileNumber,
          'centerName': centerName,
          'docId': user.uid,
          'authLevel': 2,
        }
      ])
    });

    await CenterData.centerDataCollection.doc(centerName).update({
      'adminUsers': FieldValue.arrayUnion([
        user.uid,
      ]),
    });

    await Counter.addAdminUser();
  }

  static Future<bool> updateAuthorizedUserDataFromProfilePage({
    @required mobileNumber,
    @required centerName,
    @required oldMobileNumber,
    @required oldCenterName,
    @required firstName,
    @required lastName,
    @required docId,
    @required email,
  }) async {
    await userDataCollection.doc(docId).update({
      'mobileNumber': mobileNumber,
      'centerName': centerName,
    });

    await adminUserView.doc('adminIndex').update({
      'users': FieldValue.arrayRemove([
        {
          'firstName': firstName,
          'lastName': lastName,
          'emailId': email,
          'mobileNumber': oldMobileNumber,
          'centerName': oldCenterName,
          'docId': docId,
          'authLevel': 2,
        }
      ])
    });

    await adminUserView.doc('adminIndex').update({
      'users': FieldValue.arrayUnion([
        {
          'firstName': firstName,
          'lastName': lastName,
          'emailId': email,
          'mobileNumber': mobileNumber,
          'centerName': centerName,
          'docId': docId,
          'authLevel': 2,
        }
      ])
    });

    await CenterData.centerDataCollection.doc(oldCenterName).update({
      'adminUsers': FieldValue.arrayRemove([
        docId,
      ]),
    });

    await CenterData.centerDataCollection.doc(centerName).update({
      'adminUsers': FieldValue.arrayUnion([
        docId,
      ]),
    });

    return true;
  }

//DELETE USER

  static Future<bool> deleteUser({
    uid,
  }) async {
    DocumentSnapshot userData = await userDataCollection.doc(uid).get();
    Map<String, dynamic> data = userData.data();

    bool isVerified = data['donatedBefore'];
    String firstName = data['firstName'];
    String lastName = data['lastName'];
    String mobileNumber = data['mobileNumber'];
    String email = data['emailId'];
    String bloodType = data['bloodType'];

    if (isVerified) {
      // await verifiedUserViewCollection.doc(bloodType).update({
      //   'users': FieldValue.arrayRemove([
      //     {
      //       'firstName': firstName,
      //       'lastName': lastName,
      //       'emailId': email,
      //       'mobileNumber': mobileNumber,
      //       'DOB': data['DOB'],
      //       'docId': uid,
      //     }
      //   ]),
      // });

      await verifiedUserViewCollection
          .doc(bloodType)
          .collection('verifiedView')
          .doc(uid)
          .delete();

      await Counter.deleteVerifiedUser(bloodType);
    } else {
      await nonVerifiedUserViewCollection.doc(bloodType).update({
        'users': FieldValue.arrayRemove([
          {
            'firstName': firstName,
            'lastName': lastName,
            'emailId': email,
            'mobileNumber': mobileNumber,
            'DOB': data['DOB'],
            'docId': uid,
          }
        ]),
      });

      await Counter.deleteUnverifiedUser();
    }

    await userDataCollection.doc(uid).delete();

    return true;
  }

  static Future<bool> deleteAdminUser({
    AdminUserInformation adminUser,
  }) async {
    await adminUserView.doc('adminIndex').update({
      'users': FieldValue.arrayRemove([
        {
          'firstName': adminUser.firstName,
          'lastName': adminUser.lastName,
          'emailId': adminUser.email,
          'mobileNumber': adminUser.number,
          'centerName': adminUser.centerName,
          'docId': adminUser.docId,
          'authLevel': 2,
        }
      ]),
    });

    await Counter.deleteAdminUser();

    await userDataCollection.doc(adminUser.docId).delete();

    return true;
  }

  static Future<bool> deleteWorkerUser({
    AdminUserInformation adminUser,
  }) async {
    await adminUserView.doc('adminIndex').update({
      'users': FieldValue.arrayRemove([
        {
          'firstName': adminUser.firstName,
          'lastName': adminUser.lastName,
          'emailId': adminUser.email,
          'mobileNumber': adminUser.number,
          'centerName': adminUser.centerName,
          'docId': adminUser.docId,
          'authLevel': 1,
        }
      ]),
    });

    await Counter.deleteAdminUser();

    await userDataCollection.doc(adminUser.docId).delete();

    return true;
  }

  //AUTHORIZED USERS--------------------------------------------------------

  Future<void> createWorkerUser() async {
    return await userDataCollection.doc(user.uid).set({
      'correctData': false,
      'firstName': '',
      'lastName': '',
      'emailId': user.email,
      'mobileNumber': '',
      'authorized': true,
      'centerName': '',
      'authLevel': 1,
    });
  }

  Future<void> updateWorkerUserDataFromSignIn(
      {@required firstName,
      @required lastName,
      @required mobileNumber,
      @required centerName}) async {
    await userDataCollection.doc(user.uid).update({
      'correctData': true,
      'firstName': firstName,
      'lastName': lastName,
      'emailId': user.email,
      'mobileNumber': mobileNumber,
      'authorized': true,
      'centerName': centerName,
    });

    await adminUserView.doc('adminIndex').update({
      'users': FieldValue.arrayUnion([
        {
          'firstName': firstName,
          'lastName': lastName,
          'emailId': user.email,
          'mobileNumber': mobileNumber,
          'centerName': centerName,
          'docId': user.uid,
          'authLevel': 1,
        }
      ])
    });

    await CenterData.centerDataCollection.doc(centerName).update({
      'adminUsers': FieldValue.arrayUnion([
        user.uid,
      ]),
    });

    await Counter.addAdminUser();
  }

  static Future<bool> updateWorkerUserDataFromProfilePage({
    @required mobileNumber,
    @required centerName,
    @required oldMobileNumber,
    @required oldCenterName,
    @required firstName,
    @required lastName,
    @required docId,
    @required email,
  }) async {
    await userDataCollection.doc(docId).update({
      'mobileNumber': mobileNumber,
      'centerName': centerName,
    });

    await adminUserView.doc('adminIndex').update({
      'users': FieldValue.arrayRemove([
        {
          'firstName': firstName,
          'lastName': lastName,
          'emailId': email,
          'mobileNumber': oldMobileNumber,
          'centerName': oldCenterName,
          'docId': docId,
          'authLevel': 1,
        }
      ])
    });

    await adminUserView.doc('adminIndex').update({
      'users': FieldValue.arrayUnion([
        {
          'firstName': firstName,
          'lastName': lastName,
          'emailId': email,
          'mobileNumber': mobileNumber,
          'centerName': centerName,
          'docId': docId,
          'authLevel': 1,
        }
      ])
    });

    await CenterData.centerDataCollection.doc(oldCenterName).update({
      'adminUsers': FieldValue.arrayRemove([
        docId,
      ]),
    });

    await CenterData.centerDataCollection.doc(centerName).update({
      'adminUsers': FieldValue.arrayUnion([
        docId,
      ]),
    });

    return true;
  }
}
