import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:tirbuschon_feng497/services/firestoreService.dart';

import '../BottomNavigationBarPages/mainPage.dart';

class ReviewVenue extends StatefulWidget {
  final String reservation;

  const ReviewVenue({Key? key, required this.reservation}) : super(key: key);

  @override
  _ReviewVenueState createState() => _ReviewVenueState();
}

class _ReviewVenueState extends State<ReviewVenue> {
  final filter = ProfanityFilter();
  double rating = 0.0;
  String comment = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Review the Venue"),
        ),
        backgroundColor: Colors.grey[100],
        body: Center(
          child: Column(
            children: [
              Container(
                  height: 50,
                  color: Colors.amberAccent,
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "How would you rate the venue?",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  )),
              const SizedBox(height: 50),
              RatingBar.builder(
                initialRating: 0,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (value) {
                  rating = value;
                },
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: 300,
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Add more information (optional)",
                  ),
                  onChanged: (value) {
                    setState(() {
                      comment = filter.hasProfanity(value)
                          ? filter.censor(value)
                          : value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                child: const Text(
                  "Submit your review",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  _addReview(widget.reservation, rating, comment);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ));
  }

  void _addReview(String reservationID, double rating, String? comment) async {
    var result = await FirestoreService()
        .addReview(reservationID, rating, comment)
        .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
      ));
    });

    if (result) {
      var duration = const Duration(seconds: 2);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("The review has been successfully added."),
        duration: duration,
      ));

      Future.delayed(duration, () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const MainPage()));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong while adding a review."),
      ));
    }
  }
}
