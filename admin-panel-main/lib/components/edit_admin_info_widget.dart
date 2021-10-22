import 'package:admin/Database/UserDatabase.dart';
import 'package:admin/components/form_text.dart';
import 'package:admin/models/user.dart';
import 'package:admin/pages/login.dart';
import 'package:admin/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditAdminInfoWidget extends StatefulWidget {
  EditAdminInfoWidget({
    Key key,
    @required this.user,
    @required this.reload,
    @required GlobalKey<FormState> formKey,
    @required this.centerData,
  })  : _formKey = formKey,
        super(key: key);

  final AdminUserInformation user;
  final Function reload;
  final Map<String, dynamic> centerData;
  final GlobalKey<FormState> _formKey;

  @override
  _EditAdminInfoWidgetState createState() => _EditAdminInfoWidgetState();
}

class _EditAdminInfoWidgetState extends State<EditAdminInfoWidget> {
  final TextEditingController mobileNumberController = TextEditingController();

  String centerNameVal;

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
    centerNameVal = widget.user.centerName;
    super.initState();
  }

  @override
  void dispose() {
    mobileNumberController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mobileNumberController.text = widget.user.number;

    return Container(
      width: MediaQuery.of(context).size.width * 7 / 10,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Form(
              autovalidateMode: AutovalidateMode.always,
              key: widget._formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  FormText(
                    controller: mobileNumberController,
                    validate: (val) {
                      if (val.length < 8) {
                        return 'Mobile number needs to be valid';
                      }
                      if (val.length > 10) {
                        return 'Mobile number needs to be valid';
                      }
                      return null;
                    },
                    icon: Icons.phone,
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
                  ActionButton(
                      text: "Save",
                      onPressed: () async {
                        setState(() {
                          mobileNumberController.text =
                              mobileNumberController.text.trim();
                        });

                        if (widget._formKey.currentState.validate()) {
                          if (widget.user.authLevel == 1) {
                            if (await UserDatabase
                                .updateWorkerUserDataFromProfilePage(
                                    mobileNumber: mobileNumberController.text,
                                    centerName: centerNameVal,
                                    oldMobileNumber: widget.user.number,
                                    oldCenterName: widget.user.centerName,
                                    firstName: widget.user.firstName,
                                    lastName: widget.user.lastName,
                                    docId: widget.user.docId,
                                    email: widget.user.email)) {
                              Navigator.pop(context, 'Ok');
                              widget.reload();
                            }
                          } else if (widget.user.authLevel == 2) {
                            if (await UserDatabase
                                .updateAuthorizedUserDataFromProfilePage(
                                    mobileNumber: mobileNumberController.text,
                                    centerName: centerNameVal,
                                    oldMobileNumber: widget.user.number,
                                    oldCenterName: widget.user.centerName,
                                    firstName: widget.user.firstName,
                                    lastName: widget.user.lastName,
                                    docId: widget.user.docId,
                                    email: widget.user.email)) {
                              Navigator.pop(context, 'Ok');
                              widget.reload();
                            }
                          }
                        }
                      },
                      enabled: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
