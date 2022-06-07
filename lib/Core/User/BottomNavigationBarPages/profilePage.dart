import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Review/reviewVenuePage.dart';
import '../../../services/firestoreService.dart';

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
          const _UserProfileImageContainer(),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: _profileInfo(context),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 10),
              child: Column(
                children: [_previousReservationsText(), _showReservations()],
              ))
        ],
      ),
    );
  }

  Column _profileInfo(BuildContext context) {
    return Column(
      children: const [
        _UserInfoContainer(text: "fullName", boldOption: true),
        _UserInfoContainer(text: "username", boldOption: false)
      ],
    );
  }

  Widget _previousReservationsText() {
    return const Center(
        child: Text(
      "My Reservations",
      style: TextStyle(
          fontSize: 20, color: Colors.black87, fontWeight: FontWeight.bold),
    ));
  }

  Widget _showReservations() {
    return StreamBuilder(
        stream: FirestoreService().getUserReservations(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data?.size != 0
                ? GridView.builder(
                    padding: const EdgeInsets.all(10),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var snapshotDocs = snapshot.data!.docs;
                      return TextButton(
                          onPressed: () {
                            _reservationDetail(snapshotDocs[index]);
                          },
                          child: Image.asset(
                              'assets/placeholder-restaurant-300x300.png'));
                    },
                  )
                : const Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Text("No reservations to list."),
                  );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void _reservationDetail(QueryDocumentSnapshot<Object?> snapshotDoc) async {
    var venueData =
        await FirestoreService().getVenueByID(snapshotDoc["Venue ID"]);

    var reviewData = await FirestoreService()
        .getReviewByReservationID(snapshotDoc["Reservation ID"]);

    var venueName = venueData["Venue Name"];
    var capacity = snapshotDoc["Capacity"].toString();
    var totalPrice = snapshotDoc["Total Price"].toString();
    var reservationDate = DateTime.parse(
        (snapshotDoc["Reservation Date"] as Timestamp).toDate().toString());
    var formattedDate = DateFormat('dd/MM/yyyy, HH:mm').format(reservationDate);
    var rating = reviewData["Rating"];
    var comment = reviewData["Comment"];
    var hasReview = false;

    if (rating.toString().isNotEmpty) {
      hasReview = true;
    }

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
              ReservationDetailImageContainer(
                  context: context, imageURL: venueData["imageURL"]),
              const SizedBox(height: 40),
              Flexible(
                child: Column(
                  children: [
                    _ReservationDetailContainer(
                        iconData: Icons.location_on, text: venueName),
                    const SizedBox(height: 40),
                    _ReservationDetailContainer(
                        iconData: Icons.person, text: capacity),
                    const SizedBox(height: 40),
                    _ReservationDetailContainer(
                        iconData: Icons.price_check, text: totalPrice),
                    const SizedBox(height: 40),
                    _ReservationDetailContainer(
                        iconData: Icons.date_range, text: formattedDate),
                    if (hasReview) ...[
                      const SizedBox(height: 40),
                      _ReservationDetailContainer(
                          iconData: Icons.star, text: rating.toString()),
                      const SizedBox(height: 40),
                      _ReservationDetailContainer(
                          iconData: Icons.comment, text: comment),
                    ]
                  ],
                ),
              )
            ],
          ),
          actions: [
            if (!hasReview) ...[
              _addReview(context, snapshotDoc["Reservation ID"]),
            ],
            _backToProfilePageButton(context)
          ],
        ),
      ),
    );
  }

  TextButton _backToProfilePageButton(BuildContext context) {
    return TextButton(
        onPressed: () => Navigator.pop(context), child: const Text("Back"));
  }

  TextButton _addReview(BuildContext context, String reservationID) {
    return TextButton(
        child: const Text("Add a review!"),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ReviewVenue(reservation: reservationID)));
        });
  }
}

class ReservationDetailImageContainer extends StatelessWidget {
  final BuildContext context;
  final String imageURL;

  const ReservationDetailImageContainer({
    Key? key,
    required this.imageURL,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width - 30,
        height: 250,
        decoration:
            BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
        child: Image.network(
          imageURL,
          fit: BoxFit.fill,
        ));
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
          Flexible(child: Text(text.toString())),
        ],
      ),
    );
  }
}

class _UserProfileImageContainer extends StatelessWidget {
  const _UserProfileImageContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirestoreService().getProfileInfo("avatarURL"),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data == "null") {
          return Center(
              child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 150,
                child: Center(
                  child: Image.asset('assets/placeholder.jpg'),
                )),
          ));
        }

        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 150,
              child: Center(
                child: Image.network(snapshot.data),
              )),
        );
      },
    );
  }
}

class _UserInfoContainer extends StatelessWidget {
  final String text;
  final bool boldOption;

  const _UserInfoContainer(
      {required this.text, required this.boldOption, Key? key})
      : super(key: key);

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
          child: _ProfileInfoFutureBuilder(text: text, boldOption: boldOption)),
    );
  }
}

class _ProfileInfoFutureBuilder extends StatelessWidget {
  const _ProfileInfoFutureBuilder({
    Key? key,
    required this.text,
    required this.boldOption,
  }) : super(key: key);

  final String text;
  final bool boldOption;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirestoreService().getProfileInfo(text),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return !snapshot.hasData
            ? const Center(child: CircularProgressIndicator())
            : Text(
                snapshot.data,
                style: boldOption
                    ? const TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold)
                    : const TextStyle(fontSize: 17, color: Colors.black87),
              );
      },
    );
  }
}
