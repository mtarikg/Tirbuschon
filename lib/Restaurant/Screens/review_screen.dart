import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tirbuschon_feng497/palette.dart';

class ReviewScreen extends StatefulWidget {
  final String user;
  final int rate;
  final String comment;

  ReviewScreen(
      {Key? key, required this.user, required this.rate, required this.comment})
      : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

//Venue name in docs should be passed authomatically
//line 23 will be updated
class _ReviewScreenState extends State<ReviewScreen> {
  //retrieve data from database

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
                child: StreamBuilder(
              stream: collectionReference.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    children: snapshot.data!.docs
                        .map((e) => Column(
                              children: [
                                ListTile(
                                  title: createReview(
                                      comment: e['Review'].toString(),
                                      user: e['User ID'].toString(),
                                      rate: e['Stars']),
                                ),
                              ],
                            ))
                        .toList(),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ))
          ],
        ),
      ),
    );
  }

  Widget createReview({user, rate, comment}) {
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
                  user,
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
