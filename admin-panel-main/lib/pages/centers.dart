import 'package:admin/Database/CenterDatabase.dart';
import 'package:admin/components/center_card.dart';
import 'package:admin/models/center.dart';
import 'package:admin/styles/colors.dart';
import 'package:admin/styles/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CentersPage extends StatefulWidget {
  CentersPage(this.centerData);
  final Map<String, dynamic> centerData;
  @override
  _CentersPageState createState() => _CentersPageState();
}

class _CentersPageState extends State<CentersPage> {
  ScrollController _scrollController;
  // List<CenterInformation> _centers = <CenterInformation>[
  //   CenterInformation(
  //       address: "123 King Streeet",
  //       email: "email@center.com",
  //       name: "Vashi",
  //       number: "9852222220",
  //       long: 12.2566,
  //       lat: 12.2566011)
  // ];

  getCenterNameList(map) {
    Map names = map['center_location'];

    List<String> centerNamesList = [];

    names.forEach((key, value) {
      centerNamesList.add(key);
    });

    centerNameVal = null;

    centerNameDropDownItem = [
          DropdownMenuItem<String>(
            value: null,
            child: Text(
              'None',
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

  Future indexDoc;

  String centerNameVal;

  bool showCenter = false;

  List<DropdownMenuItem<String>> centerNameDropDownItem;

  @override
  void initState() {
    getCenterNameList(widget.centerData);

    super.initState();
    _scrollController = ScrollController(initialScrollOffset: 50.0);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        showCenter == true
            ? Padding(
                padding: EdgeInsets.only(top: 100),
                child: FutureBuilder<DocumentSnapshot>(
                  future:
                      CenterData.centerDataCollection.doc(centerNameVal).get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                      Map<String, dynamic> centerData = snapshot.data.data();

                      GeoPoint location = centerData['location'];

                      CenterInformation center = CenterInformation(
                        address: centerData['address'],
                        email: centerData['emailId'],
                        name: centerData['name'],
                        number: centerData['mobileNumber'],
                        long: location.longitude,
                        lat: location.latitude,
                        contactName: centerData['contactName'],
                      );

                      return CenterTile(
                        center: center,
                        reload: () {
                          setState(() {
                            centerNameVal = centerNameVal;
                          });
                        },
                      );
                    }

                    return Text(
                      "Loading...",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              )
            : SizedBox(),
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            "Donation Centers",
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
                          showCenter = false;
                          centerNameVal = val;
                          print(centerNameVal);
                        });
                      } else {
                        setState(() {
                          showCenter = true;
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
            ],
          ),
        ),
      ],
    );
  }
}
