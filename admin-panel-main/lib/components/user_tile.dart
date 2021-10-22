import 'package:admin/Database/UserDatabase.dart';
import 'package:admin/components/delete_widget.dart';
import 'package:admin/components/edit_admin_info_widget.dart';
import 'package:admin/components/edit_user_info_widget.dart';
import 'package:admin/components/info_display_widget.dart';
import 'package:admin/models/user.dart';
import 'package:admin/pages/login.dart';
import 'package:admin/styles/colors.dart';
import 'package:admin/styles/text.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserTile extends StatelessWidget {
  UserTile({
    @required this.user,
    @required this.reload,
  });
  final UserInformation user;
  final Function reload;

  TextStyle _nameTextStyle = GoogleFonts.montserrat(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 20,
  );
  int _calculateAge(DateTime dob) {
    Duration d = DateTime.now().difference(dob);
    int days = d.inDays;
    int years = days ~/ 365;
    return years;
  }

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: secondary),
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
      child: Row(
        children: [
          CircleAvatar(
            // backgroundImage: NetworkImage(this.user.avatar),
            // onBackgroundImageError: (err, st) => {},
            radius: 24,
            backgroundColor: accent,
          ),
          Container(
            width: MediaQuery.of(context).size.width - 270,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 10),
                SelectableText(this.user.getName(), style: _nameTextStyle),
                SizedBox(
                  width: 10,
                ),
                VStatus(isVerified: this.user.verified),
                SizedBox(
                  width: 10,
                ),
                BloodGroup(bloodGrp: user.bloodGrp),
                SizedBox(
                  width: 30,
                ),
                SelectableText(this.user.email, style: userEmailandNumberStyle),
                SizedBox(
                  width: 30,
                ),
                SelectableText(this.user.number,
                    style: userEmailandNumberStyle),
                SizedBox(
                  width: 30,
                ),
                SelectableText(
                  "Age ${_calculateAge(this.user.dob)}",
                  style: userEmailandNumberStyle,
                ),
                SizedBox(
                  width: 30,
                ),
                this.user.isAdmin ? AdminTag() : SizedBox(),
                this.user.verified
                    ? (this.user.eligible == false
                        ? NotEligibleTag()
                        : SizedBox())
                    : SizedBox(),
              ],
            ),
          ),
          Container(
            height: 45,
            color: secondary,
            child: Row(
              children: [
                GestureDetector(
                  child: Icon(
                    Icons.edit,
                    color: bloodGrpColor,
                  ),
                  onTap: () {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              backgroundColor: primary,
                              title: Text(
                                'Edit User Info',
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              content: EditInfoWidget(
                                reload: reload,
                                user: user,
                                formKey: _formKey2,
                              ),
                            ));
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                !this.user.verified
                    ? SizedBox(
                        width: 10,
                      )
                    : SizedBox(),
                GestureDetector(
                  child: Icon(
                    Icons.delete,
                    color: unverifiedColor,
                  ),
                  onTap: () {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              backgroundColor: primary,
                              title: Text(
                                'Confirm Deletion',
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              content: user.verified == true
                                  ? DeleteVerifiedUser(
                                      formKey: _formKey, user: user)
                                  : DeleteUser(formKey: _formKey, user: user),
                              actions: <Widget>[
                                ActionButton(
                                  text: "Cancel",
                                  enabled: true,
                                  onPressed: () {
                                    Navigator.pop(context, "Cancel");
                                  },
                                ),
                                ActionButton(
                                  text: "Delete",
                                  enabled: true,
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      bool temp = await UserDatabase.deleteUser(
                                          uid: user.docId);
                                      print(temp);
                                      Navigator.pop(context, 'Ok');
                                      if (reload != null) {
                                        reload();
                                      }
                                    }
                                  },
                                ),
                              ],
                            ));
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  child: Icon(
                    Icons.open_in_new,
                    color: adminTagColor,
                  ),
                  onTap: () {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              backgroundColor: primary,
                              actions: [
                                ActionButton(
                                    text: "Dismiss",
                                    onPressed: () {
                                      Navigator.pop(context, 'Ok');
                                    },
                                    enabled: true)
                              ],
                              title: Text(
                                'User Info',
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              content: UserInfoDisplay(user),
                            ));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VStatus extends StatelessWidget {
  VStatus({
    @required this.isVerified,
  });
  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      // width: 130,
      padding: EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: this.isVerified
              ? verifiedColor.withOpacity(0.1)
              : unverifiedColor.withOpacity(0.1)),
      child: Icon(
        this.isVerified ? Icons.check_circle : Icons.cancel,
        color: this.isVerified
            ? verifiedColor.withOpacity(0.8)
            : unverifiedColor.withOpacity(0.8),
        size: 20,
      ),
      alignment: Alignment.center,
    );
  }
}

// ignore: must_be_immutable
class BloodGroup extends StatelessWidget {
  BloodGroup({@required this.bloodGrp});
  TextStyle _chipBaseStyle = GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );
  final String bloodGrp;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2.5),
      decoration: BoxDecoration(
          color: bloodGrpColor.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      alignment: Alignment.center,
      child: Text(bloodGrp,
          style: _chipBaseStyle.copyWith(
              color: bloodGrpColor.withOpacity(0.8),
              fontSize: _chipBaseStyle.fontSize + 2.0)),
    );
  }
}

class AdminTag extends StatelessWidget {
  TextStyle _chipBaseStyle = GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2.5),
      decoration: BoxDecoration(
          color: adminTagColor.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      alignment: Alignment.center,
      child: Text("ADMIN",
          style: _chipBaseStyle.copyWith(
            color: adminTagColor.withOpacity(0.8),
          )),
    );
  }
}

class WorkerTag extends StatelessWidget {
  TextStyle _chipBaseStyle = GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2.5),
      decoration: BoxDecoration(
          color: workerTagColor.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      alignment: Alignment.center,
      child: Text("WORKER",
          style: _chipBaseStyle.copyWith(
            color: workerTagColor.withOpacity(0.8),
          )),
    );
  }
}

class NotEligibleTag extends StatelessWidget {
  TextStyle _chipBaseStyle = GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2.5),
      decoration: BoxDecoration(
          color: adminTagColor.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      alignment: Alignment.center,
      child: Text("Donated",
          style: _chipBaseStyle.copyWith(
            color: eligibleTagColor.withOpacity(0.8),
          )),
    );
  }
}

class AdmIcon extends StatelessWidget {
  AdmIcon();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      // width: 130,
      padding: EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: adminTagColor.withOpacity(0.1)),
      child: Icon(
        Icons.error,
        color: adminTagColor.withOpacity(0.8),
        size: 20,
      ),
      alignment: Alignment.center,
    );
  }
}

class AdminUserTile extends StatelessWidget {
  AdminUserTile({
    @required this.user,
    @required this.centerData,
    @required this.reload,
  });
  final AdminUserInformation user;
  final Map centerData;
  final Function reload;

  TextStyle _nameTextStyle = GoogleFonts.montserrat(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 20,
  );

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: secondary),
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 220,
            child: Row(
              children: [
                CircleAvatar(
                  // backgroundImage: NetworkImage(this.user.avatar),
                  // onBackgroundImageError: (err, st) => {},
                  radius: 24,
                  backgroundColor: accent,
                ),
                SizedBox(width: 10),
                Text(this.user.getName(), style: _nameTextStyle),
                SizedBox(
                  width: 10,
                ),
                Text(this.user.email, style: userEmailandNumberStyle),
                SizedBox(
                  width: 30,
                ),
                Text(this.user.number, style: userEmailandNumberStyle),
                SizedBox(
                  width: 30,
                ),
                Text(this.user.centerName, style: userEmailandNumberStyle),
                SizedBox(
                  width: 30,
                ),
                this.user.authLevel == 2 ? AdminTag() : WorkerTag(),
              ],
            ),
          ),

          // Expanded(
          //   child: SizedBox(),
          // ),
          Container(
            height: 45,
            color: secondary,
            child: Row(
              children: [
                GestureDetector(
                  child: Icon(
                    Icons.edit,
                    color: bloodGrpColor,
                  ),
                  onTap: () {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              backgroundColor: primary,
                              actions: [
                                ActionButton(
                                  onPressed: () async {
                                    Navigator.pop(context, 'Cancel');
                                  },
                                  text: "Cancel",
                                  enabled: true,
                                ),
                              ],
                              title: Text(
                                'Edit user Info',
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              content: EditAdminInfoWidget(
                                reload: reload,
                                user: user,
                                formKey: _formKey2,
                                centerData: centerData,
                              ),
                            ));
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                !this.user.verified
                    ? SizedBox(
                        width: 10,
                      )
                    : SizedBox(),
                GestureDetector(
                  child: Icon(
                    Icons.delete,
                    color: unverifiedColor,
                  ),
                  onTap: () {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: Text(
                                'Confirm Deletion',
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: primary,
                              content: DeleteAdminUser(
                                  formKey: _formKey, user: user),
                              actions: <Widget>[
                                ActionButton(
                                    text: "Cancel",
                                    onPressed: () {
                                      Navigator.pop(context, 'Cancel');
                                    },
                                    enabled: true),
                                ActionButton(
                                  text: "Delete",
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      if (user.authLevel == 2) {
                                        bool temp =
                                            await UserDatabase.deleteAdminUser(
                                                adminUser: user);
                                      } else if (user.authLevel == 1) {
                                        bool temp =
                                            await UserDatabase.deleteWorkerUser(
                                                adminUser: user);
                                      }

                                      if (reload != null) {
                                        reload();
                                      }
                                      Navigator.pop(context, 'Ok');
                                    }
                                  },
                                  enabled: true,
                                )
                              ],
                            ));
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  child: Icon(
                    Icons.open_in_new,
                    color: adminTagColor,
                  ),
                  onTap: () {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              backgroundColor: primary,
                              actions: [
                                ActionButton(
                                    text: "Dismiss",
                                    onPressed: () {
                                      Navigator.pop(context, 'Ok');
                                    },
                                    enabled: true)
                              ],
                              title: Text(
                                'User Info',
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              content: AdminInfoDisplay(user: user),
                            ));
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
