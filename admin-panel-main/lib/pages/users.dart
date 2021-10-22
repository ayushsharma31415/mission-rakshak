import 'package:admin/Database/UserDatabase.dart';
import 'package:admin/components/dropdown_menue_items.dart';
import 'package:admin/components/user_tile.dart';
import 'package:admin/models/user.dart';
import 'package:admin/pages/back_up_user_data.dart';
import 'package:admin/pages/login.dart';
import 'package:admin/styles/colors.dart';
import 'package:admin/styles/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

enum Search { filter, nameSearch }
enum Filters { verified, unverified, admin, numberOfDonations }

class UserList extends StatefulWidget {
  UserList(this.centerData);
  final Map<String, dynamic> centerData;
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  ScrollController _scrollController;

  Filters userTypeVal = Filters.verified;
  // String userTypeVal = 'V';
  String bloodTypeVal = 'O+';

  Search typeOfSearch = Search.nameSearch;

  String searchBarType = 'firstName';

  DocumentSnapshot lastVisible;

  TextEditingController _searchController;
  // List<UserInformation> _users = <UserInformation>[
  //   UserInformation(
  //       bloodGrp: 'O+',
  //       email: 'krishaay@test.com',
  //       name: 'Krishaay Jois',
  //       number: '+11 9911991199',
  //       verified: false,
  //       avatar:
  //           'https://media.discordapp.net/attachments/844423821666549770/845994234791460864/macos-catalina-1920x1080-night-mountains-wwdc-2019-5k-21589.jpg?width=1202&height=676',
  //       dob: DateTime.now().subtract(Duration(days: 365 * 56)),
  //       isAdmin: true),
  //   UserInformation(
  //       bloodGrp: 'O+',
  //       email: 'krishaay@test.com',
  //       name: 'Krishaay Jois',
  //       number: '+11 9911991199',
  //       verified: true,
  //       avatar:
  //           'https://media.discordapp.net/attachments/844423821666549770/845994234791460864/macos-catalina-1920x1080-night-mountains-wwdc-2019-5k-21589.jpg?width=1202&height=676',
  //       dob: DateTime.now().subtract(Duration(days: 365 * 56)),
  //       isAdmin: false),
  // ];

  getSearchBarHint(typeOfBar) {
    if (typeOfBar == 'firstName') {
      return 'Enter Name';
    }
    if (typeOfBar == 'lastName') {
      return 'Enter Last Name';
    }
    if (typeOfBar == 'userId') {
      return 'Enter ID';
    }
  }

  Widget getSearchQuery(searchText) {
    if (searchText.length >= 3) {
      dynamic usersStream;
      if (searchBarType == 'firstName') {
        usersStream = UserDatabase.userDataCollection
            .orderBy("firstName")
            .where("firstName", isGreaterThanOrEqualTo: searchText)
            .where("firstName", isLessThanOrEqualTo: searchText + "z")
            .snapshots();
      }
      if (searchBarType == 'lastName') {
        usersStream = UserDatabase.userDataCollection
            .orderBy("lastName")
            .where("lastName", isGreaterThanOrEqualTo: searchText)
            .where("lastName", isLessThanOrEqualTo: searchText + "z")
            .snapshots();
      }

      if (searchBarType == 'userId') {
        usersStream = UserDatabase.userDataCollection
            .where(FieldPath.documentId, isEqualTo: searchText)
            .snapshots();
      }

      return StreamBuilder<QuerySnapshot>(
        stream: usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text(
              'Something went wrong',
              style: TextStyle(
                color: Colors.white,
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text(
              "Loading...",
              style: TextStyle(
                color: Colors.white,
              ),
            );
          }

          return new ListView(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            addAutomaticKeepAlives: true,
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> curUser = document.data();

              if (!curUser['authorized']) {
                Timestamp dob = curUser['DOB'];
                String firstName = curUser['firstName'];
                String lastName = curUser['lastName'];
                String email = curUser['emailId'];
                String mobileNumber = curUser['mobileNumber'];
                String bloodType = curUser['bloodType'];
                bool isVerified = curUser['donatedBefore'];
                String docId = document.reference.id;

                UserInformation curUserInfo = UserInformation(
                    bloodGrp: bloodType,
                    email: email,
                    firstName: firstName,
                    lastName: lastName,
                    number: mobileNumber,
                    verified: isVerified,
                    docId: docId,
                    eligible: true,
                    avatar:
                        'https://media.discordapp.net/attachments/844423821666549770/845994234791460864/macos-catalina-1920x1080-night-mountains-wwdc-2019-5k-21589.jpg?width=1202&height=676',
                    dob:
                        DateTime.fromMillisecondsSinceEpoch(dob.seconds * 1000),
                    isAdmin: false);

                return UserTile(
                  user: curUserInfo,
                  reload: () {
                    setState(() {
                      typeOfSearch = Search.nameSearch;
                    });
                  },
                );
              }
              if (curUser['authorized']) {
                Map<String, dynamic> curUser = document.data();
                String centerName = curUser['centerName'];
                String firstName = curUser['firstName'];
                String lastName = curUser['lastName'];
                String email = curUser['emailId'];
                String mobileNumber = curUser['mobileNumber'];
                String docId = document.reference.id;

                AdminUserInformation curUserInfo = AdminUserInformation(
                    authLevel: curUser['authLevel'],
                    email: email,
                    firstName: firstName,
                    lastName: lastName,
                    number: mobileNumber,
                    docId: docId,
                    verified: true,
                    avatar:
                        'https://media.discordapp.net/attachments/844423821666549770/845994234791460864/macos-catalina-1920x1080-night-mountains-wwdc-2019-5k-21589.jpg?width=1202&height=676',
                    centerName: centerName,
                    isAdmin: true);

                return AdminUserTile(
                  user: curUserInfo,
                  centerData: widget.centerData,
                  reload: () {
                    setState(() {
                      typeOfSearch = Search.nameSearch;
                    });
                  },
                );
              }
            }).toList(),
          );
        },
      );
    } else {
      return Text(
        "Give at least 3 letters to search users",
        style: TextStyle(
          color: Colors.white,
        ),
      );
    }
  }

  Widget getViewQuery(userType, bloodType) {
    if (userType == Filters.admin) {
      Future futureDoc = UserDatabase.adminUserView.doc('adminIndex').get();

      return FutureBuilder<DocumentSnapshot>(
        future: futureDoc,
        // CenterData.getNearestCenterWithDocument(
        //     latitude: latitude, longitude: longitude, index: centerData),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text(
              "Something went wrong",
              style: TextStyle(
                color: Colors.white,
              ),
            );
          }

          if ((snapshot.hasData && !snapshot.data.exists)) {
            return Text(
              "Something went wrong",
              style: TextStyle(
                color: Colors.white,
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> adminViewData = snapshot.data.data();
            List adminUsers = adminViewData['users'];

            if (adminUsers == null || adminUsers.isEmpty) {
              return Text(
                "There are no users for this filter",
                style: TextStyle(
                  color: Colors.white,
                ),
              );
            }

            return ListView.separated(
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
                addAutomaticKeepAlives: true,
                itemCount: adminUsers.length,
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
                itemBuilder: (BuildContext context, int index) {
                  Map user = adminUsers[index];
                  String centerName = user['centerName'];
                  String firstName = user['firstName'];
                  String lastName = user['lastName'];
                  String email = user['emailId'];
                  String mobileNumber = user['mobileNumber'];
                  String docId = user['docId'];

                  AdminUserInformation curUser = AdminUserInformation(
                      authLevel: user['authLevel'],
                      email: email,
                      firstName: firstName,
                      lastName: lastName,
                      number: mobileNumber,
                      verified: true,
                      docId: docId,
                      avatar:
                          'https://media.discordapp.net/attachments/844423821666549770/845994234791460864/macos-catalina-1920x1080-night-mountains-wwdc-2019-5k-21589.jpg?width=1202&height=676',
                      centerName: centerName,
                      isAdmin: true);

                  return AdminUserTile(
                    user: curUser,
                    centerData: widget.centerData,
                    reload: () {
                      setState(() {
                        typeOfSearch = Search.filter;
                      });
                    },
                  );
                });
          }

          return Text(
            "Loading...",
            style: TextStyle(
              color: Colors.white,
            ),
          );
        },
      );
    }
    if (userType == Filters.verified) {
      dynamic usersStream;
      if (lastVisible == null) {
        usersStream = UserDatabase.verifiedUserViewCollection
            .doc(bloodType)
            .collection('verifiedView')
            .orderBy('donations', descending: true)
            .limit(20)
            .snapshots();
      } else {
        usersStream = UserDatabase.verifiedUserViewCollection
            .doc(bloodType)
            .collection('verifiedView')
            .orderBy('donations', descending: true)
            .startAtDocument(lastVisible)
            .limit(20)
            .snapshots();
      }

      return StreamBuilder<QuerySnapshot>(
        stream: usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text(
              'Something went wrong',
              style: TextStyle(
                color: Colors.white,
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text(
              "Loading...",
              style: TextStyle(
                color: Colors.white,
              ),
            );
          }

          if (snapshot.data.docs.length - 1 >= 0) {
            lastVisible = snapshot.data.docs[snapshot.data.docs.length - 1];
          }

          return new ListView(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            addAutomaticKeepAlives: true,
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> curUser = document.data();

              Timestamp dob = curUser['DOB'];
              String firstName = curUser['firstName'];
              String lastName = curUser['lastName'];
              String email = curUser['emailId'];
              String mobileNumber = curUser['mobileNumber'];
              String docId = curUser['docId'];

              DateTime lastDonation = DateTime.fromMillisecondsSinceEpoch(
                  curUser['lastDonation'].seconds * 1000);

              int donationDuration =
                  DateTime.now().difference(lastDonation).inDays;
              bool eligible = false;

              print(donationDuration);
              if (donationDuration > 45) {
                eligible = true;
              }

              UserInformation curUserInfo = UserInformation(
                  bloodGrp: bloodType,
                  email: email,
                  firstName: firstName,
                  lastName: lastName,
                  number: mobileNumber,
                  verified: true,
                  docId: docId,
                  eligible: eligible,
                  avatar:
                      'https://media.discordapp.net/attachments/844423821666549770/845994234791460864/macos-catalina-1920x1080-night-mountains-wwdc-2019-5k-21589.jpg?width=1202&height=676',
                  dob: DateTime.fromMillisecondsSinceEpoch(dob.seconds * 1000),
                  isAdmin: false);

              return UserTile(
                user: curUserInfo,
                reload: () {},
              );
            }).toList(),
          );
        },
      );

      // return FutureBuilder<DocumentSnapshot>(
      //   future: futureDoc,
      //   // CenterData.getNearestCenterWithDocument(
      //   //     latitude: latitude, longitude: longitude, index: centerData),
      //   builder:
      //       (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      //     if (snapshot.hasError) {
      //       return Text(
      //         "Something went wrong",
      //         style: TextStyle(
      //           color: Colors.white,
      //         ),
      //       );
      //     }
      //
      //     if ((snapshot.hasData && !snapshot.data.exists)) {
      //       return Text(
      //         "Something went wrong",
      //         style: TextStyle(
      //           color: Colors.white,
      //         ),
      //       );
      //     }
      //
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       Map<String, dynamic> userViewData = snapshot.data.data();
      //       List usersView = userViewData['users'];
      //
      //       if (usersView == null || usersView.isEmpty) {
      //         return Text(
      //           "There are no users for this filter",
      //           style: TextStyle(
      //             color: Colors.white,
      //           ),
      //         );
      //       }
      //
      //       return ListView.separated(
      //           controller: _scrollController,
      //           physics: BouncingScrollPhysics(),
      //           addAutomaticKeepAlives: true,
      //           itemCount: usersView.length,
      //           separatorBuilder: (BuildContext context, int index) =>
      //               Divider(),
      //           itemBuilder: (BuildContext context, int index) {
      //             Map user = usersView[index];
      //             Timestamp dob = user['DOB'];
      //             String firstName = user['firstName'];
      //             String lastName = user['lastName'];
      //             String email = user['emailId'];
      //             String mobileNumber = user['mobileNumber'];
      //             String docId = user['docId'];
      //
      //             UserInformation curUser = UserInformation(
      //                 bloodGrp: bloodType,
      //                 email: email,
      //                 firstName: firstName,
      //                 lastName: lastName,
      //                 number: mobileNumber,
      //                 verified: true,
      //                 docId: docId,
      //                 avatar:
      //                     'https://media.discordapp.net/attachments/844423821666549770/845994234791460864/macos-catalina-1920x1080-night-mountains-wwdc-2019-5k-21589.jpg?width=1202&height=676',
      //                 dob: DateTime.fromMillisecondsSinceEpoch(
      //                     dob.seconds * 1000),
      //                 isAdmin: false);
      //
      //             return UserTile(user: curUser);
      //           });
      //     }
      //
      //     return Text(
      //       "Loading...",
      //       style: TextStyle(
      //         color: Colors.white,
      //       ),
      //     );
      //   },
      // );
    }
    if (userType == Filters.unverified) {
      Future futureDoc =
          UserDatabase.nonVerifiedUserViewCollection.doc(bloodType).get();
      return FutureBuilder<DocumentSnapshot>(
        future: futureDoc,
        // CenterData.getNearestCenterWithDocument(
        //     latitude: latitude, longitude: longitude, index: centerData),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text(
              "Please check your internet and try again",
              style: TextStyle(
                color: Colors.white,
              ),
            );
          }

          if ((snapshot.hasData && !snapshot.data.exists)) {
            return Text(
              "Please check your internet and try again",
              style: TextStyle(
                color: Colors.white,
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> userViewData = snapshot.data.data();

            List usersView = userViewData['users'].reversed.toList();

            if (usersView == null || usersView.isEmpty) {
              return Text(
                "There are no users for this filter",
                style: TextStyle(
                  color: Colors.white,
                ),
              );
            }

            return ListView.separated(
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
                addAutomaticKeepAlives: true,
                itemCount: usersView.length,
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
                itemBuilder: (BuildContext context, int index) {
                  if (index - usersView.length < -6000) {
                    Map user = usersView[index];
                    String docId = user['docId'];
                    UserDatabase.deleteUser(uid: docId);

                    return SizedBox();
                  }

                  Map user = usersView[index];
                  Timestamp dob = user['DOB'];
                  String firstName = user['firstName'];
                  String lastName = user['lastName'];
                  String email = user['emailId'];
                  String mobileNumber = user['mobileNumber'];
                  String docId = user['docId'];

                  UserInformation curUser = UserInformation(
                      bloodGrp: bloodType,
                      email: email,
                      firstName: firstName,
                      lastName: lastName,
                      number: mobileNumber,
                      verified: false,
                      docId: docId,
                      eligible: false,
                      avatar:
                          'https://media.discordapp.net/attachments/844423821666549770/845994234791460864/macos-catalina-1920x1080-night-mountains-wwdc-2019-5k-21589.jpg?width=1202&height=676',
                      dob: DateTime.fromMillisecondsSinceEpoch(
                          dob.seconds * 1000),
                      isAdmin: false);

                  return UserTile(
                    user: curUser,
                    reload: () {
                      setState(() {
                        typeOfSearch = Search.filter;
                      });
                    },
                  );
                });
          }

          return Text(
            "Loading...",
            style: TextStyle(
              color: Colors.white,
            ),
          );
        },
      );
    }

    // if (userType == Filters.numberOfDonations) {
    //   dynamic verifiedUserStream;
    //   // verifiedUserStream = UserDatabase.userDataCollection
    //   //     .where("donatedBefore", isEqualTo: true)
    //   //     .where("bloodType", isEqualTo: bloodTypeVal)
    //   //     .orderBy('donations')
    //   //     .snapshots();
    //
    //
    //   // Future futureDoc = UserDatabase.userDataCollection.doc(bloodType).get();
    //
    //   return StreamBuilder<QuerySnapshot>(
    //     stream: verifiedUserStream,
    //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //       if (snapshot.hasError) {
    //         return Text(
    //           'Something went wrong',
    //           style: TextStyle(
    //             color: Colors.white,
    //           ),
    //         );
    //       }
    //
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return Text(
    //           "Loading...",
    //           style: TextStyle(
    //             color: Colors.white,
    //           ),
    //         );
    //       }
    //
    //       return new ListView(
    //         controller: _scrollController,
    //         physics: BouncingScrollPhysics(),
    //         addAutomaticKeepAlives: true,
    //         children: snapshot.data.docs.map((DocumentSnapshot document) {
    //           Map<String, dynamic> curUser = document.data();
    //           Timestamp dob = curUser['DOB'];
    //           String firstName = curUser['firstName'];
    //           String lastName = curUser['lastName'];
    //           String email = curUser['emailId'];
    //           String mobileNumber = curUser['mobileNumber'];
    //           String bloodType = curUser['bloodType'];
    //           bool isVerified = curUser['donatedBefore'];
    //           String docId = document.reference.id;
    //
    //           UserInformation curUserInfo = UserInformation(
    //               bloodGrp: bloodType,
    //               email: email,
    //               firstName: firstName,
    //               lastName: lastName,
    //               number: mobileNumber,
    //               verified: isVerified,
    //               docId: docId,
    //               avatar:
    //                   'https://media.discordapp.net/attachments/844423821666549770/845994234791460864/macos-catalina-1920x1080-night-mountains-wwdc-2019-5k-21589.jpg?width=1202&height=676',
    //               dob: DateTime.fromMillisecondsSinceEpoch(dob.seconds * 1000),
    //               isAdmin: false);
    //
    //           return UserTile(user: curUserInfo);
    //         }).toList(),
    //       );
    //     },
    //   );
    //
    // }
  }

  getSearchWidget(typeOfSearch, searchText) {
    if (typeOfSearch == Search.filter) {
      return getViewQuery(userTypeVal, bloodTypeVal);
    } else if (typeOfSearch == Search.nameSearch) {
      return getSearchQuery(searchText);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 180),
          child: getSearchWidget(typeOfSearch, _searchController.text),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            "User List",
            style: pageTitleStyle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50, left: 10),
          child: Row(
            children: [
              Container(
                width: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: TextField(
                  enableInteractiveSelection: true,
                  autocorrect: false,
                  autofocus: true,
                  controller: _searchController,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  textCapitalization: TextCapitalization.words,
                  textAlignVertical: TextAlignVertical.center,
                  cursorColor: accent,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  decoration: InputDecoration(
                    border: null,
                    fillColor: secondary,
                    hintText: getSearchBarHint(searchBarType),
                    hintStyle: GoogleFonts.montserrat(
                      color: searchHelperColor,
                    ),
                    filled: true,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: accent,
                  ),
                  height: 50,
                  width: 100,
                  child: Center(
                    child: Text(
                      "Search",
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    typeOfSearch = Search.nameSearch;
                    // _scrollController =
                    //     ScrollController(initialScrollOffset: 50.0);
                  });
                },
              ),
              SizedBox(width: 30),
              DropdownButton(
                value: searchBarType,
                dropdownColor: secondary,
                hint: Text(
                  "Search Type",
                  style: GoogleFonts.montserrat(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onChanged: (val) {
                  setState(() {
                    print(val);
                    searchBarType = val;
                  });

                  // _scrollController =
                  //     ScrollController(initialScrollOffset: 50.0);
                },
                icon: Icon(
                  Icons.arrow_downward,
                  color: Colors.white,
                ),
                items: searchBarTypeList,
              ),
              SizedBox(width: 10),
              Spacer(),
              GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: accent,
                  ),
                  height: 40,
                  width: 200,
                  child: Center(
                    child: Text(
                      "Back Up",
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) =>
                            AlertDialog(actions: [
                              ActionButton(
                                  text: "Cancel",
                                  onPressed: () {
                                    Navigator.pop(context, 'Cancel');
                                  },
                                  enabled: true)
                            ], backgroundColor: primary, content: BackUp()));
                  });
                },
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 120, left: 10),
          child: Row(
            children: [
              DropdownButton(
                value: userTypeVal,
                dropdownColor: secondary,
                hint: Text(
                  "User Type",
                  style: GoogleFonts.montserrat(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onChanged: (val) {
                  setState(() {
                    lastVisible = null;

                    typeOfSearch = Search.filter;
                    userTypeVal = val;
                  });

                  // _scrollController =
                  //     ScrollController(initialScrollOffset: 50.0);
                },
                icon: Icon(
                  Icons.arrow_downward,
                  color: Colors.white,
                ),
                items: userTypeList,
              ),
              SizedBox(width: 10),
              userTypeVal == Filters.admin
                  ? Container(height: 0, width: 0)
                  : DropdownButton(
                      value: bloodTypeVal,
                      dropdownColor: secondary,
                      hint: Text(
                        "Blood Type",
                        style: GoogleFonts.montserrat(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onChanged: (val) {
                        setState(() {
                          lastVisible = null;

                          typeOfSearch = Search.filter;
                          bloodTypeVal = val;
                        });

                        // _scrollController =
                        //     ScrollController(initialScrollOffset: 50.0);
                      },
                      icon: Icon(
                        Icons.arrow_downward,
                        color: Colors.white,
                      ),
                      items: bloodTypeList,
                    ),
              SizedBox(width: 10),
              GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: accent,
                  ),
                  height: 50,
                  width: 100,
                  child: Center(
                    child: Text(
                      "Search",
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    typeOfSearch = Search.filter;
                    lastVisible = null;
                    // _scrollController =
                    //     ScrollController(initialScrollOffset: 50.0);
                  });
                },
              ),
              SizedBox(width: 15),
              userTypeVal == Filters.verified
                  ? Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              lastVisible = null;
                            });
                          },
                          child: Icon(
                            Icons.chevron_left,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 7),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              userTypeVal = Filters.verified;
                            });
                          },
                          child: Icon(
                            Icons.chevron_right,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}

/*

            controller: _scrollController,
            radius: Radius.circular(10),
            showTrackOnHover: true,
            isAlwaysShown: true,
            thickness: 2,

Fook Scrollbars all ma homies h8 scrollbars

*/
