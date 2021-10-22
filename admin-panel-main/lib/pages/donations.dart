import 'package:admin/Database/donationHistory.dart';
import 'package:admin/components/donation_log_tile.dart';
import 'package:admin/models/log.dart';
import 'package:admin/styles/colors.dart';
import 'package:admin/styles/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DonationHistory extends StatefulWidget {
  DonationHistory({this.userData, this.centerData});
  final Map<String, dynamic> userData;
  final Map<String, dynamic> centerData;
  @override
  _DonationHistoryState createState() => _DonationHistoryState();
}

class _DonationHistoryState extends State<DonationHistory> {
  ScrollController _scrollController;

  Future indexDoc2;

  String centerNameVal;
  List<DropdownMenuItem<String>> centerNameDropDownItem;

  String donationDisplayVal = 'None';
  String donationEntryVal = 'None';
  List<DropdownMenuItem<String>> donationEntryDropDownItem;

  String displayText = 'Please Select A Month';

  Map displayList = {'None': 'None'};

  Map<String, String> months = {
    "1": "January",
    "2": "February",
    "3": "March",
    "4": "April",
    "5": "May",
    "6": "June",
    "7": "July",
    "8": "August",
    "9": "September",
    "10": "October",
    "11": "November",
    "12": "December",
  };

  getCenterNameList(map) {
    Map names = map['center_location'];

    List<String> centerNamesList = [];

    names.forEach((key, value) {
      centerNamesList.add(key);
    });

    centerNameDropDownItem = [
          DropdownMenuItem<String>(
            value: 'All',
            child: Text(
              'All',
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
            ),
          )
        ] +
        centerNamesList.map((e) {
          return DropdownMenuItem<String>(
            value: e,
            child: Text(
              e,
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
            ),
          );
        }).toList();
  }

  Widget getViewQuery(donationEntryVal, centerNameVal) {
    if (donationEntryVal != "None") {
      return FutureBuilder<DocumentSnapshot>(
        future: DonationHistoryData.donationHistoryCollection
            .doc(donationEntryVal)
            .get(),
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
            Map<String, dynamic> donationHistoryData = snapshot.data.data();
            List donationHistoryList = donationHistoryData['history'];

            if (donationHistoryList == null || donationHistoryList.isEmpty) {
              return Text(
                "There are no donations for this filter",
                style: TextStyle(
                  color: Colors.white,
                ),
              );
            }
            donationHistoryList = donationHistoryList.reversed.toList();

            print(donationHistoryList);

            List donationHistoryCenterList = [];

            if (centerNameVal != 'All') {
              for (Map i in donationHistoryList) {
                if (centerNameVal == i['centerName']) {
                  donationHistoryCenterList.add(i);
                }
              }
            } else {
              donationHistoryCenterList = donationHistoryList;
            }

            print(donationHistoryCenterList);
            String currentDay;

            if (donationHistoryCenterList == null ||
                donationHistoryCenterList.isEmpty) {
              return Text(
                "There are no donations for this filter",
                style: TextStyle(
                  color: Colors.white,
                ),
              );
            }

            return ListView.separated(
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
                addAutomaticKeepAlives: true,
                itemCount: donationHistoryCenterList.length,
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
                itemBuilder: (BuildContext context, int index) {
                  Map historyLog = donationHistoryCenterList[index];
                  String centerName = historyLog['centerName'];
                  String name = historyLog['name'];
                  String bloodType = historyLog['bloodType'];
                  Timestamp time = historyLog['timeStamp'];
                  String docId = historyLog['userId'];
                  DateTime datetime =
                      DateTime.fromMillisecondsSinceEpoch(time.seconds * 1000);

                  DonationLog curDonation = DonationLog(
                    bloodType: bloodType,
                    centerName: centerName,
                    timestamp: datetime,
                    userID: docId,
                    userName: name,
                  );

                  if (currentDay != datetime.day.toString()) {
                    currentDay = datetime.day.toString();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            currentDay,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        LogTile(log: curDonation),
                      ],
                    );
                  }
                  return LogTile(log: curDonation);
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
    } else {
      return SizedBox();
    }
  }

  String getDisplayText(String text) {
    List words = text.split('_');
    return months[words[0]] + '  ' + words[1];
  }

  @override
  void initState() {
    indexDoc2 =
        DonationHistoryData.donationHistoryCollection.doc('entryList').get();

    getCenterNameList(widget.centerData);

    centerNameVal = widget.userData['centerName'];

    super.initState();
    _scrollController = ScrollController();
  }

  // List<DonationLog> _logs = <DonationLog>[
  //   DonationLog(
  //     bloodType: 'O+',
  //     centerName: 'Vashi',
  //     timestamp: DateTime.now(),
  //     userID: 'arnavchintawar',
  //     userName: 'Arnav Chintawar',
  //   )
  // ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 100.0, left: 20),
          child: Text(
            displayText,
            // displayText == 'Please Select A Month'
            //     ? 'Please Select A Month'
            //     : getDisplayText(displayText),
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 150.0),
          child: getViewQuery(donationEntryVal, centerNameVal),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            "Donation Logs",
            style: pageTitleStyle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50, left: 10),
          child: Row(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 13,
                  ),
                  Icon(
                    Icons.apartment,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  DropdownButton(
                    value: centerNameVal,
                    dropdownColor: secondary,
                    hint: Text(
                      "Center Name",
                      style: GoogleFonts.montserrat(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onChanged: (val) {
                      if (val == null) {
                        setState(() {
                          centerNameVal = val;
                          print(centerNameVal);
                        });
                      } else {
                        setState(() {
                          centerNameVal = val;
                          print(centerNameVal);
                        });
                      }
                    },
                    icon: Icon(
                      Icons.arrow_downward,
                      color: Colors.white,
                    ),
                    items: centerNameDropDownItem,
                  ),
                ],
              ),
              SizedBox(
                width: 30,
              ),
              FutureBuilder<DocumentSnapshot>(
                future: indexDoc2,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text(
                      "please check internet",
                      style: TextStyle(color: Colors.white),
                    );
                  }

                  if ((snapshot.hasData && !snapshot.data.exists)) {
                    return Text(
                      "please check internet",
                      style: TextStyle(color: Colors.white),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    Map data = snapshot.data.data();
                    List donationEntryiList = data['entries'];

                    donationEntryDropDownItem = [
                          DropdownMenuItem<String>(
                            value: 'None',
                            child: Text(
                              'None',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300),
                            ),
                          )
                        ] +
                        donationEntryiList.reversed.map((e) {
                          List words = e.split('_');
                          String displayString =
                              months[words[0]] + '  ' + words[1];
                          displayList[displayString] = e;

                          return DropdownMenuItem<String>(
                            value: displayString,
                            child: Text(
                              displayString,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300),
                            ),
                          );
                        }).toList();

                    return Row(
                      children: [
                        SizedBox(
                          width: 13,
                        ),
                        Icon(
                          Icons.event,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        DropdownButton(
                          value: donationDisplayVal,
                          dropdownColor: secondary,
                          hint: Text(
                            "Month",
                            style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onChanged: (val) {
                            if (val == 'None') {
                              setState(() {
                                donationEntryVal = val;
                                donationDisplayVal = val;
                                print(donationEntryVal);
                              });
                              setState(() {
                                displayText = 'Please Select A Month';
                              });
                            } else {
                              setState(() {
                                donationEntryVal = displayList[val];
                                donationDisplayVal = val;

                                print(donationEntryVal);
                              });
                              setState(() {
                                displayText = donationDisplayVal;
                              });
                            }
                          },
                          icon: Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                          ),
                          items: donationEntryDropDownItem,
                        )
                      ],
                    );
                  }

                  return Text(
                    "Loading.........",
                    style: TextStyle(color: Colors.white),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
