import 'package:admin/components/add_donation.dart';
import 'package:admin/components/add_request.dart';
import 'package:admin/components/add_center.dart';
import 'package:admin/pages/centers.dart';
import 'package:admin/pages/dashboard.dart';
import 'package:admin/pages/donations.dart';
import 'package:admin/pages/login.dart';
import 'package:admin/pages/requests.dart';
import 'package:admin/pages/settings.dart';
import 'package:admin/pages/users.dart';
import 'package:flutter/material.dart';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin/styles/colors.dart';

enum pages { dash, settings, users, requests, dontaions, centers }

class AppContainer extends StatefulWidget {
  AppContainer(this.userData, this.centerData);
  final Map<String, dynamic> userData;
  final Map<String, dynamic> centerData;
  @override
  _AppContainerState createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  pages _selectedPage = pages.dash;
  Widget _currentPage;
  FloatingActionButton _fab;

  Widget _getCurrentScreen(pages page) {
    _selectedPage = page;
    switch (page) {
      case pages.dash:
        _fab = null;
        return Dashboard();
        break;
      case pages.centers:
        _fab = FloatingActionButton(
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
            backgroundColor: accent,
            onPressed: () {
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        backgroundColor: primary,
                        content: AddCenter(widget.centerData),
                      ));
            });
        return CentersPage(widget.centerData);

        break;
      case pages.dontaions:
        _fab = FloatingActionButton(
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
            backgroundColor: accent,
            onPressed: () {
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        backgroundColor: primary,
                        content: AddDonation(
                          centerData: widget.centerData,
                          userData: widget.userData,
                        ),
                      ));
            });
        return DonationHistory(
            centerData: widget.centerData, userData: widget.userData);
        break;
      case pages.requests:
        _fab = FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
          backgroundColor: accent,
          onPressed: () {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      backgroundColor: primary,
                      content: CreateRequest(
                        centerData: widget.centerData,
                        userData: widget.userData,
                      ),
                      actions: [
                        ActionButton(
                            text: "Cancel",
                            onPressed: () async {
                              Navigator.pop(context, 'Cancel');
                            },
                            enabled: true),
                      ],
                    ));
          },
        );
        return DonationRequests(widget.centerData, widget.userData);
        break;
      case pages.users:
        _fab = null;
        return UserList(widget.centerData);
        break;
      case pages.settings:
        _fab = null;
        return Settings();

        break;
    }
  }

  @override
  void initState() {
    _currentPage = Dashboard();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: _fab,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        backgroundColor: primary,
        body: CollapsibleSidebar(
            duration: Duration(seconds: 1),
            selectedIconBox: activeNavColor.withOpacity(0.25),
            selectedIconColor: activeNavColor,
            toggleButtonIcon: Icons.navigate_next,
            titleStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
            toggleTitleStyle: GoogleFonts.montserrat(fontSize: 20),
            unselectedIconColor: inactiveNavColor,
            title: 'Admin',
            selectedTextColor: activeNavColor,
            avatarImg: AssetImage('assets/img/logo.png'),
            textStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold, fontSize: 28),
            // fitItemsToBottom: true,
            toggleTitle: 'Collapse',
            showToggleButton: false,
            items: <CollapsibleItem>[
              CollapsibleItem(
                  isSelected: _selectedPage == pages.dash ? true : false,
                  icon: Icons.assessment,
                  text: 'Dashboard',
                  onPressed: () {
                    setState(() {
                      _currentPage = _getCurrentScreen(pages.dash);
                    });
                  }),
              CollapsibleItem(
                  isSelected: _selectedPage == pages.users ? true : false,
                  icon: Icons.account_box,
                  text: 'Users',
                  onPressed: () {
                    setState(() {
                      _currentPage = _getCurrentScreen(pages.users);
                    });
                  }),
              CollapsibleItem(
                  isSelected: _selectedPage == pages.centers ? true : false,
                  icon: Icons.room,
                  text: 'Centers',
                  onPressed: () {
                    setState(() {
                      _currentPage = _getCurrentScreen(pages.centers);
                    });
                  }),
              CollapsibleItem(
                  isSelected: _selectedPage == pages.dontaions ? true : false,
                  icon: Icons.invert_colors,
                  text: 'Donations',
                  onPressed: () {
                    setState(() {
                      _currentPage = _getCurrentScreen(pages.dontaions);
                    });
                  }),
              CollapsibleItem(
                  isSelected: _selectedPage == pages.requests ? true : false,
                  icon: Icons.wifi_tethering,
                  text: 'Requests',
                  onPressed: () {
                    setState(() {
                      _currentPage = _getCurrentScreen(pages.requests);
                    });
                  }),
            ],
            body: _currentPage));
  }
}
