import 'package:flutter/material.dart';
import 'package:tirbuschon_feng497/Restaurant/Screens/menu_screen.dart';
import 'package:tirbuschon_feng497/Restaurant/Screens/photographs_screen.dart';
import 'package:tirbuschon_feng497/Restaurant/Screens/profile_screen.dart';
import 'package:tirbuschon_feng497/Restaurant/Screens/reservations_screen.dart';
import 'package:tirbuschon_feng497/Restaurant/Screens/review_screen.dart';
import 'package:tirbuschon_feng497/palette.dart';

/// BOTTOM_NAVIGATION BAR
class VenueMainScreen extends StatelessWidget {
  const VenueMainScreen({
    Key? key,
    this.index = 0,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: index,
      length: 5,
      child: Scaffold(
        body: TabBarView(
          children: <Widget>[
            const MenuScreen(),
            PhotographsScreen(),
            ReservationScreen(
                PartySize: 0,
                // orders: [],
                UserID: 0,
                //ReservationID: 0,
                ReservationDate: 'dd/MM/yyyy',
                CreatedDate: 'dd/MM/yyyy',
                TotalPrice: 0),
            ReviewScreen(
              CreatedDate: 'dd/MM/yyyy',
              Rating: 0,
              Comment: '',
            ),
            const ProfileScreen(
              address: '',
              name: '',
              phone: '',
              reservationCapacity: 0,
              capacity: 0,
            ),
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
            tabs: [
              Tab(
                icon: Icon(Icons.menu, size: 28),
              ),
              Tab(
                icon: Icon(Icons.photo_library, size: 28),
              ),
              Tab(
                icon: Icon(Icons.list, size: 28),
              ),
              Tab(
                icon: Icon(Icons.reviews, size: 28),
              ),
              Tab(
                icon: Icon(Icons.person, size: 28),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
