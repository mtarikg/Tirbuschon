import 'package:flutter/material.dart';
import 'package:tirbuschon_feng497/palette.dart';

class ReviewScreen extends StatefulWidget {
  final String user;
  final String rate;
  final String comment;

  ReviewScreen(
      {Key? key, required this.user, required this.rate, required this.comment})
      : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Reviews',
          style: TextStyle(color: Colors.black87, fontFamily: 'Montserrat'),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05,
            bottom: MediaQuery.of(context).size.width * 0.05,
            top: MediaQuery.of(context).size.width * 0.04),
        child: Column(
          children: <Widget>[
            createReview(user: 'X User', rate: '', comment: 'Comments'),
            createReview(user: 'X User', rate: '', comment: 'Comments'),
            createReview(user: 'X User', rate: '', comment: 'Comments'),
            createReview(user: 'X User', rate: '', comment: 'Comments'),
            createReview(user: 'X User', rate: '', comment: 'Comments'),
            createReview(user: 'X User', rate: '', comment: 'Comments'),
            createReview(user: 'X User', rate: '', comment: 'Comments'),
            createReview(user: 'X User', rate: '', comment: 'Comments'),
          ],
        ),
      )),
    );
  }

  Widget createReview({user, rate, comment}) {
    return Container(
      height: 90,
      width: MediaQuery.of(context).size.width * 0.9,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: primaryLightWhite,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          right: MediaQuery.of(context).size.width * 0.05,
          left: MediaQuery.of(context).size.width * 0.05,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  user,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star_border,
                      color: Colors.black,
                    ),
                    Icon(
                      Icons.star_border,
                      color: Colors.black,
                    ),
                    Icon(
                      Icons.star_border,
                      color: Colors.black,
                    ),
                    Icon(
                      Icons.star_border,
                      color: Colors.black,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      comment,
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
