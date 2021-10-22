import 'package:admin/Database/UserDatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DonationHistoryData {
  static final CollectionReference donationHistoryCollection =
      FirebaseFirestore.instance.collection('donationHistory');

  static Future<bool> createDonationLog({
    @required name,
    @required bloodType,
    @required centerName,
    @required userId,
  }) async {
    Timestamp date = Timestamp.now();
    DateTime datetime =
        DateTime.fromMillisecondsSinceEpoch(date.seconds * 1000);
    String dateString = '${datetime.month}_${datetime.year}';

    await donationHistoryCollection.doc(dateString).set(
        {
          'history': FieldValue.arrayUnion([
            {
              'bloodType': bloodType,
              'name': name,
              'centerName': centerName,
              'timeStamp': Timestamp.now(),
              'userId': userId,
            }
          ]),
        },
        SetOptions(
          merge: true,
        ));

    await UserDatabase.userDataCollection.doc(userId).update({
      'previousDonations': FieldValue.arrayUnion([
        {
          'centerName': centerName,
          'timeStamp': Timestamp.now(),
        }
      ]),
      'donations': FieldValue.increment(1),
    });

    await UserDatabase.verifiedUserViewCollection
        .doc(bloodType)
        .collection('verifiedView')
        .doc(userId)
        .update({
      'donations': FieldValue.increment(1),
      'lastDonation': date,
    });

    await donationHistoryCollection.doc('entryList').update({
      'entries': FieldValue.arrayUnion([dateString])
    });

    return true;
  }

  //TODO: check if this function works

  static Future<void> deleteDonationLog({
    @required name,
    @required bloodType,
    @required centerName,
    @required userId,
    @required timeStampOfEntry,
  }) async {
    Timestamp date = Timestamp.now();
    DateTime datetime =
        DateTime.fromMillisecondsSinceEpoch(date.seconds * 1000);
    String dateString = '${datetime.month}_${datetime.year}';
    await donationHistoryCollection.doc(dateString).update({
      'history': FieldValue.arrayRemove([
        {
          //need all feild of map to delete successfully
          'bloodType': bloodType,
          'name': name,
          'centerName': centerName,
          'timeStamp': timeStampOfEntry,
          'userId': userId,
        }
      ]),
    });
  }
}
