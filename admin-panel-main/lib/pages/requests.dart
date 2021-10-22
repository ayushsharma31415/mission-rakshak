import 'package:admin/Database/RequextDatabase.dart';
import 'package:admin/components/dropdown_menue_items.dart';
import 'package:admin/components/request_card.dart';
import 'package:admin/models/request.dart';
import 'package:admin/styles/colors.dart';
import 'package:admin/styles/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DonationRequests extends StatefulWidget {
  DonationRequests(this.centerData, this.userData);

  final Map<String, dynamic> centerData;
  final Map<String, dynamic> userData;

  @override
  _DonationRequestsState createState() => _DonationRequestsState();
}

class _DonationRequestsState extends State<DonationRequests> {
  ScrollController _scrollController;
  @override
  // List<Request> _requests = <Request>[
  //   Request(bloodType: 'O+', centerName: 'Vashi', urgency: 0)
  // ];

  Future requestDataSnapshot;

  String centerNameVal;
  List<DropdownMenuItem<String>> centerNameDropDownItem;

  int urgencyTypeVal = 3;
  List<DropdownMenuItem> urgencyTypeDropDownItem = [
        DropdownMenuItem(
          value: 3,
          child: Text(
            'All',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
          ),
        )
      ] +
      urgencyList;

  String bloodTypeVal = 'All';
  List<DropdownMenuItem<String>> bloodTypeDropDown = [
        DropdownMenuItem<String>(
          value: 'All',
          child: Text(
            'All',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
          ),
        )
      ] +
      bloodTypeList;

  String displayText = 'Please Select Center';

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

  Widget getViewQuery(bloodTypeVal, centerNameVal, urgencyTypeVal) {
    return FutureBuilder<DocumentSnapshot>(
      future: requestDataSnapshot,
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
          Map<String, dynamic> requestData = snapshot.data.data();
          Map requestListData = requestData['allRequests'];

          List requestList = [];
          requestListData.forEach((key, value) {
            requestList.add(value);
          });

          if (requestList == null || requestList.isEmpty) {
            return Text(
              "There are no current requests in any center",
              style: TextStyle(
                color: Colors.white,
              ),
            );
          }

          List filteredRequestList = [];

          if (urgencyTypeVal != 3) {
            for (dynamic i in requestList) {
              // print(centerNameVal);
              // print(i[0][0]);
              if (urgencyTypeVal == i[3]) {
                print(centerNameVal);
                print(i[0]);
                // print(i[0]);
                filteredRequestList.add(i);
              }
              // print(i);
            }
          }
          if (urgencyTypeVal == 3) {
            filteredRequestList = requestList;
          }

          List filteredRequestList2 = [];

          if (centerNameVal != 'All' && bloodTypeVal == 'All') {
            for (dynamic i in filteredRequestList) {
              // print(centerNameVal);
              // print(i[0][0]);
              if (centerNameVal == i[0]) {
                print(centerNameVal);
                print(i[0]);
                // print(i[0]);
                filteredRequestList2.add(i);
              }
              // print(i);
            }
          }
          if (centerNameVal == 'All' && bloodTypeVal != 'All') {
            for (List i in filteredRequestList) {
              print(centerNameVal);
              print(i[1]);
              if (bloodTypeVal == i[1]) {
                filteredRequestList2.add(i);
              }
            }
          }
          if (centerNameVal != 'All' && bloodTypeVal != 'All') {
            for (List i in filteredRequestList) {
              print(centerNameVal);
              print(i[0]);
              print(i[1]);
              if (bloodTypeVal == i[1] && centerNameVal == i[0]) {
                filteredRequestList2.add(i);
              }
            }
          }
          if (centerNameVal == 'All' && bloodTypeVal == 'All') {
            filteredRequestList2 = filteredRequestList;
          }

          // print(filteredRequestList2);

          if (filteredRequestList2 == null || filteredRequestList2.isEmpty) {
            return Text(
              "There are no requests for this filter",
              style: TextStyle(
                color: Colors.white,
              ),
            );
          }

          return ListView.separated(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              addAutomaticKeepAlives: true,
              itemCount: filteredRequestList2.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemBuilder: (BuildContext context, int index) {
                List requestData = filteredRequestList2[index];
                String centerName = requestData[0];
                String bloodType = requestData[1];
                Timestamp time = requestData[2];
                int priority = requestData[3];
                DateTime datetime =
                    DateTime.fromMillisecondsSinceEpoch(time.seconds * 1000);

                Request curRequest = Request(
                    bloodType: bloodType,
                    centerName: centerName,
                    urgency: priority,
                    dateTime: datetime);

                // if (currentDay != datetime.day.toString()) {
                //   currentDay = datetime.day.toString();
                //   return Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Padding(
                //         padding: const EdgeInsets.only(left: 10),
                //         child: Text(
                //           currentDay,
                //           style: TextStyle(color: Colors.white, fontSize: 20),
                //         ),
                //       ),
                //       LogTile(log: curDonation),
                //     ],
                //   );
                // }
                return RequestTile(
                  request: curRequest,
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

  @override
  void initState() {
    requestDataSnapshot =
        RequestData.bloodRequestCollection.doc('requestView').get();

    getCenterNameList(widget.centerData);

    centerNameVal = widget.userData['centerName'];

    displayText = centerNameVal;

    // RequestData.createBloodDonationRequest(
    //     name: 'sanpada', priorityLevel: 2, bloodType: 'O+');

    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 100.0, left: 20),
          child: Text(
            displayText,
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 150.0),
          child: getViewQuery(bloodTypeVal, centerNameVal, urgencyTypeVal),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            "Requests",
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
                      if (val == 'All') {
                        setState(() {
                          centerNameVal = val;
                          print(centerNameVal);
                          displayText = 'All Center';
                        });
                      } else {
                        setState(() {
                          centerNameVal = val;
                          print(centerNameVal);
                          displayText = centerNameVal;
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
              Row(
                children: [
                  SizedBox(
                    width: 13,
                  ),
                  Icon(
                    Icons.opacity,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  DropdownButton(
                    value: bloodTypeVal,
                    dropdownColor: secondary,
                    hint: Text(
                      "Blood Type",
                      style: GoogleFonts.montserrat(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onChanged: (val) {
                      setState(() {
                        bloodTypeVal = val;
                        print(bloodTypeVal);
                      });
                    },
                    icon: Icon(
                      Icons.arrow_downward,
                      color: Colors.white,
                    ),
                    items: bloodTypeDropDown,
                  )
                ],
              ),
              SizedBox(
                width: 30,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 13,
                  ),
                  Icon(
                    Icons.notification_important,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  DropdownButton(
                    value: urgencyTypeVal,
                    dropdownColor: secondary,
                    hint: Text(
                      "Urgency",
                      style: GoogleFonts.montserrat(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onChanged: (val) {
                      setState(() {
                        urgencyTypeVal = val;
                        print(urgencyTypeVal);
                      });
                    },
                    icon: Icon(
                      Icons.arrow_downward,
                      color: Colors.white,
                    ),
                    items: urgencyTypeDropDownItem,
                  ),
                ],
              ),
              SizedBox(width: 20),
              GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: accent,
                  ),
                  height: 40,
                  width: 90,
                  child: Center(
                    child: Text(
                      "Reload",
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    requestDataSnapshot = RequestData.bloodRequestCollection
                        .doc('requestView')
                        .get();
                    // _scrollController =
                    //     ScrollController(initialScrollOffset: 50.0);
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
