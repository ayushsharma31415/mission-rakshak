import 'package:admin/Database/CenterDatabase.dart';
import 'package:admin/Database/Counter.dart';
import 'package:admin/Database/RequextDatabase.dart';
import 'package:admin/Database/donationHistory.dart';
import 'package:admin/pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:admin/styles/text.dart';
import 'package:admin/components/dashboard_card.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  ScrollController _scrollController;

  Future userCount;
  Future requestCount;
  Future monthList;
  Future centerData;

  @override
  void initState() {
    centerData = CenterData.centerDataCollection.doc('index').get();

    monthList =
        DonationHistoryData.donationHistoryCollection.doc('entryList').get();

    userCount = Counter.counterCollection.doc('user').get();

    requestCount = RequestData.bloodRequestCollection.doc('requestView').get();

    // CenterData.updateLocationDonationCenter(
    //     name: 'seawoods', latitude: 18.993669999999998, longitude: 73.005094);

    super.initState();
    _scrollController = ScrollController(initialScrollOffset: 50.0);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        physics: BouncingScrollPhysics(),
        controller: _scrollController,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 155,
              ),
              Text(
                "DashBoard",
                style: pageTitleStyle,
              ),
              Spacer(),
              ActionButton(text: "Sign Out", onPressed: _logout, enabled: true),
            ],
          ),
          Row(
            children: [
              FutureBuilder<DocumentSnapshot>(
                future: userCount,
                // CenterData.getNearestCenterWithDocument(
                //     latitude: latitude, longitude: longitude, index: centerData),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return ErrorDashCard(
                      title: "Users",
                      data: 'please check\n your internet',
                      icon: Icons.account_box,
                    );
                  }

                  if ((snapshot.hasData && !snapshot.data.exists)) {
                    return ErrorDashCard(
                      title: "Users",
                      data: 'please check\n your internet',
                      icon: Icons.account_box,
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> users = snapshot.data.data();
                    int adminUsers = users['adminCount'];
                    int verifiedUsers = users['verifiedCount'];
                    int unverifiedUsers = users['unverifiedCount'];

                    return UserCount(
                      count: users,
                      title: "Users",
                      verified_users: verifiedUsers.toString(),
                      unverified_users: unverifiedUsers.toString(),
                      admin_users: adminUsers.toString(),
                      icon: Icons.account_box,
                    );
                  }
                  return ErrorDashCard(
                    title: "Users",
                    data: 'loading..',
                    icon: Icons.account_box,
                  );
                },
              ),
              FutureBuilder<DocumentSnapshot>(
                future: monthList,
                // CenterData.getNearestCenterWithDocument(
                //     latitude: latitude, longitude: longitude, index: centerData),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return ErrorDashCard(
                      title: "Donations\nthis Month",
                      data: 'please check\n your internet',
                      icon: Icons.opacity,
                    );
                  }

                  if ((snapshot.hasData && !snapshot.data.exists)) {
                    return ErrorDashCard(
                      title: "Donations\nthis Month",
                      data: 'please check\n your internet',
                      icon: Icons.opacity,
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> months = snapshot.data.data();
                    String month = months['entries'].last;

                    Future curMonth = DonationHistoryData
                        .donationHistoryCollection
                        .doc(month)
                        .get();

                    return FutureBuilder<DocumentSnapshot>(
                      future: curMonth,
                      // CenterData.getNearestCenterWithDocument(
                      //     latitude: latitude, longitude: longitude, index: centerData),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return ErrorDashCard(
                            title: "Donations\nthis Month",
                            data: 'please check\n your internet',
                            icon: Icons.opacity,
                          );
                        }

                        if ((snapshot.hasData && !snapshot.data.exists)) {
                          return ErrorDashCard(
                            title: "Donations\nthis Month",
                            data: 'please check\n your internet',
                            icon: Icons.opacity,
                          );
                        }

                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> curMonth = snapshot.data.data();
                          int donations = curMonth['history'].length;

                          return DashCard(
                            title: "Donations\nthis Month",
                            data: donations.toString(),
                            icon: Icons.opacity,
                          );
                        }

                        return ErrorDashCard(
                          title: "Donations\nthis Month",
                          data: 'loading..',
                          icon: Icons.opacity,
                        );
                      },
                    );
                  }
                  return ErrorDashCard(
                    title: "Donations\nthis Month",
                    data: 'loading..',
                    icon: Icons.opacity,
                  );
                },
              ),
            ],
          ),
          Row(
            children: [
              FutureBuilder<DocumentSnapshot>(
                future: requestCount,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return ErrorDashCard(
                      title: "Requests",
                      data: 'please check\n your internet',
                      icon: Icons.wifi_tethering,
                    );
                  }

                  if ((snapshot.hasData && !snapshot.data.exists)) {
                    return ErrorDashCard(
                      title: "Requests",
                      data: 'please check\n your internet',
                      icon: Icons.wifi_tethering,
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> users = snapshot.data.data();
                    int requestCount = users['allRequests'].length;

                    return DashCard(
                      title: "Requests",
                      data: requestCount.toString(),
                      icon: Icons.wifi_tethering,
                    );
                  }
                  return ErrorDashCard(
                    title: "Requests",
                    data: 'loading..',
                    icon: Icons.wifi_tethering,
                  );
                },
              ),
              FutureBuilder<DocumentSnapshot>(
                future: centerData,
                // CenterData.getNearestCenterWithDocument(
                //     latitude: latitude, longitude: longitude, index: centerData),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return ErrorDashCard(
                      title: "Centers",
                      data: 'please check\n your internet',
                      icon: Icons.room,
                    );
                  }

                  if ((snapshot.hasData && !snapshot.data.exists)) {
                    return ErrorDashCard(
                      title: "Centers",
                      data: 'please check\n your internet',
                      icon: Icons.room,
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> centers = snapshot.data.data();

                    int centerNum = 0;

                    Map names = centers['center_location'];

                    centerNum = names.length;

                    return DashCard(
                      title: "Centers",
                      data: centerNum.toString(),
                      icon: Icons.room,
                    );
                  }
                  return ErrorDashCard(
                    title: "Centers",
                    data: 'loading..',
                    icon: Icons.room,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
