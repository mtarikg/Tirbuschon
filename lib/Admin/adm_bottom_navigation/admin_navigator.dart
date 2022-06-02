import 'package:flutter/material.dart';
import 'package:tirbuschon_feng497/Admin/add_new_restaurant/page/rest_add_page.dart';
import 'package:tirbuschon_feng497/Admin/view_restaurant_screen/view_restautants.dart';
import 'package:tirbuschon_feng497/Admin/view_users/view_all_users.dart';
import 'package:tirbuschon_feng497/palette.dart';

//BOTTOM_NAVIGATION BAR

class AdminBottomNavBar extends StatelessWidget {
  const AdminBottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: TabBarView(
          children: <Widget>[
            AdminSignUpPage(),
            ViewAllRestaurants(),
            ViewAllUsers(),
          ],
        ),
        bottomNavigationBar: Material(
          color: primaryLightOrange,
          child: const TabBar(
            labelPadding: EdgeInsets.only(bottom: 10),
            labelStyle: TextStyle(fontSize: 16.0),
            indicatorColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black54,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.add, size: 28),
              ),
              Tab(
                icon: Icon(Icons.menu, size: 28),
              ),
              Tab(
                icon: Icon(Icons.person,size: 28),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
