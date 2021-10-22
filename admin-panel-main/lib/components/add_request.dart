import 'package:admin/Database/RequextDatabase.dart';
import 'package:admin/components/dropdown_menue_items.dart';
import 'package:admin/pages/login.dart';
import 'package:admin/styles/colors.dart';
import 'package:admin/styles/text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateRequest extends StatefulWidget {
  CreateRequest({
    Key key,
    @required this.userData,
    @required this.centerData,
  }) : super(key: key);

  final Map<String, dynamic> userData;
  final Map<String, dynamic> centerData;

  @override
  _CreateRequestState createState() => _CreateRequestState();
}

class _CreateRequestState extends State<CreateRequest> {
  final TextEditingController mobileNumberController = TextEditingController();

  String centerNameVal;
  String bloodTypeVal = 'O-';
  int urgencyTypeVal = 2;

  List<DropdownMenuItem<String>> centerNameDropDownItem;

  getCenterNameList(map) {
    Map names = map['center_location'];

    List<String> centerNamesList = [];

    names.forEach((key, value) {
      centerNamesList.add(key);
    });

    centerNameDropDownItem = centerNamesList.map((e) {
      return DropdownMenuItem<String>(
        value: e,
        child: Text(
          e,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
        ),
      );
    }).toList();
  }

  @override
  void initState() {
    getCenterNameList(widget.centerData);
    centerNameVal = widget.userData['centerName'];
    super.initState();
  }

  @override
  void dispose() {
    mobileNumberController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Center(
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 60,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: primary,
                          ),
                          child: Row(
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
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
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
                                items: bloodTypeList,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 60,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: primary,
                          ),
                          child: Row(
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
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    centerNameVal = val;
                                    print(centerNameVal);
                                  });
                                },
                                icon: Icon(
                                  Icons.arrow_downward,
                                  color: Colors.white,
                                ),
                                items: centerNameDropDownItem,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 60,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: primary,
                          ),
                          child: Row(
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
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
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
                                items: urgencyList,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ActionButton(
                          onPressed: () async {
                            bool temp =
                                await RequestData.createBloodDonationRequest(
                                    name: centerNameVal,
                                    priorityLevel: urgencyTypeVal,
                                    bloodType: bloodTypeVal);

                            Navigator.pop(context, 'Ok');
                          },
                          text: "Create",
                          enabled: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              "Add Request",
              style: pageTitleStyle,
            ),
          ),
        ],
      ),
    );
  }
}
