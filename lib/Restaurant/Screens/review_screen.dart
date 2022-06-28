import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tirbuschon_feng497/palette.dart';

import '../../services/firestoreService.dart';

class ReviewScreen extends StatefulWidget {
  final String Comment;
  final String CreatedDate;
  final int Rating;
  // final int ReservationID;
  // final int ReviewID;

  ReviewScreen({
    Key? key,
    required this.Comment,
    required this.CreatedDate,
    required this.Rating,
    //required this.ReservationID,
    //required this.ReviewID,
  }) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late CollectionReference collectionReference;

  @override
  void initState() {
    String userId = FirebaseAuth.instance.currentUser!.uid.toString();
    collectionReference = FirebaseFirestore.instance
        .collection('Venues')
        .doc(userId)
        .collection('Reviews');
    super.initState();
  }

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
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream:
                        collectionReference.orderBy('Created Date').snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasData) {
                        return ListView(
                            children: snapshot.data!.docs
                                .map((e) => FutureBuilder(
                                    future: getUsername(e['User ID']),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<dynamic> secondSnapshot) {
                                      if (secondSnapshot.hasData) {
                                        return ListTile(
                                          title: createReview(
                                              username: secondSnapshot.data,
                                              comment: e['Comment'],
                                              CreatedDate: DateFormat.yMMMd()
                                                  .add_jm()
                                                  .format(e['Created Date']
                                                      .toDate()
                                                      .toLocal()),
                                              rate: e['Rating']),
                                        );
                                      } else {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }
                                    }))
                                .toList());
                      }
                      return const Center(child: CircularProgressIndicator());
                    }))
          ],
        ),
      ),
    );
  }

  Widget createReview({username, rate, comment, CreatedDate}) {
    return Container(
      height: 90,
      width: MediaQuery.of(context).size.width * 0.96,
      margin: const EdgeInsets.only(bottom: 10),
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
                  comment,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                Row(
                  children: [
                    IconTheme(
                      data: IconThemeData(
                        color: primaryOrange,
                        size: 20,
                      ),
                      child: StarDisplay(value: rate),
                    ),
                  ],
                ),
              ],
            ),
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    username.toString().replaceRange(
                        1, null, "*" * (username.toString().length - 1)),
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      CreatedDate.toString(),
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

  getUsername(userID) async {
    var usernameValue =
        await FirestoreService().getProfileInfo(userID.toString(), 'fullName');

    return usernameValue;
  }
}

class StarDisplayWidget extends StatelessWidget {
  final int value;
  final Widget filledStar;
  final Widget unfilledStar;
  const StarDisplayWidget({
    Key? key,
    this.value = 0,
    required this.filledStar,
    required this.unfilledStar,
  })  : assert(value != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return index < value ? filledStar : unfilledStar;
      }),
    );
  }
}

class StarDisplay extends StarDisplayWidget {
  const StarDisplay({Key? key, int value = 0})
      : super(
          key: key,
          value: value,
          filledStar: const Icon(Icons.star),
          unfilledStar: const Icon(Icons.star_border),
        );
}
