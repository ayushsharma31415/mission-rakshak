import 'package:admin/pages/data_reciever.dart';
import 'package:admin/pages/loading.dart';
import 'package:admin/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Root(),
    routes: {
      '/auth': (context) => Root(),
    },
  ));
}

// class StartPage extends StatelessWidget {
//   final Future<FirebaseApp> _initialization = Firebase.initializeApp();
//   @override
//   Widget build(BuildContext context) {
//       return FutureBuilder(
//       future: _initialization,
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Center(
//             child: Text("Something Went wrong"),
//           );
//         }
//         if (snapshot.connectionState == ConnectionState.done) {
//           return Root();
//         }
//         //loading
//         return LoadingScreen();
//       },
//     );
//   }
//}

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<User> get user => _auth.authStateChanges();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data?.uid == null) {
            return Login();
          } else {
            return UserDataReceiver();
          }
        } else {
          return LoadingScreen();
        }
      }, //Auth stream
    );
  }
}
