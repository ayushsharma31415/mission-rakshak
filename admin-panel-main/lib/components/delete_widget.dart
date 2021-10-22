import 'package:admin/components/form_text.dart';
import 'package:admin/models/user.dart';
import 'package:admin/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteAdminUser extends StatefulWidget {
  const DeleteAdminUser({
    Key key,
    @required GlobalKey<FormState> formKey,
    @required this.user,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final AdminUserInformation user;

  @override
  _DeleteAdminUserState createState() => _DeleteAdminUserState();
}

class _DeleteAdminUserState extends State<DeleteAdminUser> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 300,
      child: Column(
        children: [
          Text(
            'Enter the name of user to delete. This is done to make sure that you are deleting the one want to',
            style: GoogleFonts.montserrat(color: Colors.white),
          ),
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
                TextFormField(
                  validator: (val) {
                    if (val != widget.user.getName()) {
                      return 'the name entered is not correct';
                    }
                    return null;
                  },
                  autocorrect: false,
                  autofocus: true,
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  textCapitalization: TextCapitalization.words,
                  textAlignVertical: TextAlignVertical.center,
                  cursorColor: accent,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  decoration: InputDecoration(
                    border: null,
                    fillColor: secondary,
                    hintText: widget.user.getName(),
                    hintStyle: GoogleFonts.montserrat(
                      color: searchHelperColor,
                    ),
                    filled: true,
                    prefixIcon: Icon(
                      Icons.account_circle,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DeleteUser extends StatefulWidget {
  const DeleteUser({
    Key key,
    @required GlobalKey<FormState> formKey,
    @required this.user,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final UserInformation user;

  @override
  _DeleteUserState createState() => _DeleteUserState();
}

class _DeleteUserState extends State<DeleteUser> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 100,
      child: Column(
        children: [
          Text('Are you sure you want to delete this user?',
              style: GoogleFonts.montserrat(
                color: Colors.white,
              )),
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
                Text(
                  widget.user.getName(),
                  style: GoogleFonts.montserrat(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                // FormText(
                //   controller: _nameController,
                //   hintText: widget.user.getName(),
                //   validate: (val) {
                //     if (val != widget.user.getName()) {
                //       return 'the name entered is not correct';
                //     }
                //     return null;
                //   },
                //   icon: Icons.person,
                // ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DeleteVerifiedUser extends StatefulWidget {
  const DeleteVerifiedUser({
    Key key,
    @required GlobalKey<FormState> formKey,
    @required this.user,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final UserInformation user;

  @override
  _DeleteVerifiedUserState createState() => _DeleteVerifiedUserState();
}

class _DeleteVerifiedUserState extends State<DeleteVerifiedUser> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 300,
      child: Column(
        children: [
          Text(
            'Enter the name of user to delete. This is done to make sure that you are deleting the one want to',
            style: GoogleFonts.montserrat(color: Colors.white),
          ),
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
                FormText(
                  controller: _nameController,
                  hintText: widget.user.firstName,
                  validate: (val) {
                    if (val != widget.user.firstName) {
                      return 'the name entered is not correct';
                    }
                    return null;
                  },
                  icon: Icons.person,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
