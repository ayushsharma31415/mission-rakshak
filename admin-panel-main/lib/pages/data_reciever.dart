import 'package:admin/Database/CenterDatabase.dart';
import 'package:admin/Database/UserDatabase.dart';
import 'package:admin/app_container.dart';
import 'package:admin/pages/error_pages/no_info.dart';
import 'package:admin/pages/loading.dart';
import 'package:admin/pages/error_pages/unauth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// dynamic data;
// getUserData() async {
//   data = await UserDatabase.userDataCollection
//       .doc(FirebaseAuth.instance.currentUser.uid)
//       .get();
//   data = data.data();
// }

// UserDatabase database=UserDatabase(FirebaseAuth.instance.currentUser.);

//
// String getUserName() {
//   return data.firstName;
// }

class UserDataReceiver extends StatefulWidget {
  @override
  _UserDataReceiverState createState() => _UserDataReceiverState();
}

class _UserDataReceiverState extends State<UserDataReceiver> {
  @override
  Widget build(BuildContext context) {
    Future<List<DocumentSnapshot>> getData() async {
      DocumentSnapshot userData = await UserDatabase.userDataCollection
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get();
      DocumentSnapshot centerData =
          await CenterData.centerDataCollection.doc('index').get();
      if (!centerData.exists) {
        return null;
      }
      return [userData, centerData];
    }

    return FutureBuilder<List<DocumentSnapshot>>(
      future: getData(),
      builder: (BuildContext context,
          AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasError) {
          return Text('no internet');
          //return NoInternetPage();
        }

        if ((snapshot.hasData)) {
          List data = snapshot.data;
          if (!data[0].exists) {
            return NoInfo();
          }
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null) {
            return Text('no internet');
            //return NoInternetPage();
          }
          List data = snapshot.data;
          Map<String, dynamic> userData = data[0].data();
          Map<String, dynamic> centerData = data[1].data();

          if (userData['authorized']) {
            if (userData['correctData']) {
              if (userData['authLevel'] == 2) {
                return AppContainer(userData, centerData);
              }
              return NotAuthorized();
            }
            return NoInfo();
            //return AuthInputPage(centerData);
          } else {
            return NotAuthorized();
          }
        }

        return LoadingScreen();
      },
    );
  }
}
