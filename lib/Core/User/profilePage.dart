import 'dart:ui';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          _profileImage(),
          _profileInfo(context),
          _previousReservationsText(),
          _showReservations()
        ],
      ),
    );
  }

  Padding _profileInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: const [
          _UserInfoContainer(text: "Username"),
          _UserInfoContainer(text: "Full Name"),
          _UserInfoContainer(text: "Social Media Accounts"),
        ],
      ),
    );
  }

  Center _profileImage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: 100,
          width: 100,
          child: Image.network(
            "https://cdn.pixabay.com/photo/2021/05/19/14/31/dandelion-6266230_960_720.jpg",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Padding _previousReservationsText() {
    return const Padding(
      padding: EdgeInsets.only(top: 40, bottom: 10),
      child: Center(
          child: Text(
        "My Previous Reservations",
        style: TextStyle(
            fontSize: 20, color: Colors.black87, fontWeight: FontWeight.bold),
      )),
    );
  }

  Widget _showReservations() {
    final photoLinks = [
      'https://cwdaust.com.au/wpress/wp-content/uploads/2015/04/placeholder-restaurant-300x300.png',
      'https://thumbs.dreamstime.com/z/restaurant-placeholder-vector-icon-symbol-location-isolated-white-background-eps-restaurant-placeholder-vector-icon-symbol-159301081.jpg',
      'https://cwdaust.com.au/wpress/wp-content/uploads/2015/04/placeholder-restaurant-300x300.png',
      'https://thumbs.dreamstime.com/z/restaurant-placeholder-vector-icon-symbol-location-isolated-white-background-eps-restaurant-placeholder-vector-icon-symbol-159301081.jpg',
      'https://cwdaust.com.au/wpress/wp-content/uploads/2015/04/placeholder-restaurant-300x300.png',
      'https://cwdaust.com.au/wpress/wp-content/uploads/2015/04/placeholder-restaurant-300x300.png',
      'https://thumbs.dreamstime.com/z/restaurant-placeholder-vector-icon-symbol-location-isolated-white-background-eps-restaurant-placeholder-vector-icon-symbol-159301081.jpg',
      'https://cwdaust.com.au/wpress/wp-content/uploads/2015/04/placeholder-restaurant-300x300.png',
      'https://cwdaust.com.au/wpress/wp-content/uploads/2015/04/placeholder-restaurant-300x300.png',
      'https://thumbs.dreamstime.com/z/restaurant-placeholder-vector-icon-symbol-location-isolated-white-background-eps-restaurant-placeholder-vector-icon-symbol-159301081.jpg',
      'https://cwdaust.com.au/wpress/wp-content/uploads/2015/04/placeholder-restaurant-300x300.png',
      'https://cwdaust.com.au/wpress/wp-content/uploads/2015/04/placeholder-restaurant-300x300.png',
      'https://thumbs.dreamstime.com/z/restaurant-placeholder-vector-icon-symbol-location-isolated-white-background-eps-restaurant-placeholder-vector-icon-symbol-159301081.jpg',
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
      ),
      itemCount: photoLinks.length,
      itemBuilder: (context, index) {
        return TextButton(
            onPressed: () {
              _reservationDetail(photoLinks[index]);
            },
            child: Image.network(photoLinks[index]));
      },
    );
  }

  void _reservationDetail(var photo) {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: AlertDialog(
          title: const Text("Reservation Detail"),
          scrollable: true,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _imageContainer(context, photo),
              const SizedBox(height: 40),
              Flexible(
                child: Column(
                  children: const [
                    _ReservationDetailContainer(
                        iconData: Icons.person, text: "Venue Name"),
                    SizedBox(height: 40),
                    _ReservationDetailContainer(
                        iconData: Icons.info, text: "Reservation Description"),
                    SizedBox(height: 40),
                    _ReservationDetailContainer(
                        iconData: Icons.star_rate_sharp, text: "Your Rating"),
                    SizedBox(height: 40),
                    _ReservationDetailContainer(
                        iconData: Icons.rate_review_rounded,
                        text: "Your Comment"),
                  ],
                ),
              )
            ],
          ),
          actions: [_backToProfilePageButton(context)],
        ),
      ),
    );
  }

  Container _imageContainer(BuildContext context, photo) {
    return Container(
        width: MediaQuery.of(context).size.width - 30,
        height: 250,
        decoration:
            BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
        child: Image.network(
          photo,
          fit: BoxFit.fill,
        ));
  }

  TextButton _backToProfilePageButton(BuildContext context) {
    return TextButton(
        onPressed: () => Navigator.pop(context), child: const Text("Back"));
  }
}

class _ReservationDetailContainer extends StatelessWidget {
  final IconData iconData;
  final String text;

  const _ReservationDetailContainer({
    required this.iconData,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Icon(iconData),
          const SizedBox(width: 5),
          Flexible(child: Text(text)),
        ],
      ),
    );
  }
}

class _UserInfoContainer extends StatelessWidget {
  final String text;

  const _UserInfoContainer({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
              top: BorderSide(width: 1, color: Colors.grey),
              bottom: BorderSide(width: 1, color: Colors.grey))),
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Center(
          child: Text(
        text,
        style: const TextStyle(fontSize: 20, color: Colors.black87),
      )),
    );
  }
}
