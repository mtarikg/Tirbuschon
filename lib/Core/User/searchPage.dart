import 'package:flutter/material.dart';
import '../../services/firestoreService.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var venues = [];

  getVenues() async {
    var venuesData = await FirestoreService().getCurrentVenues();

    setState(() {
      venuesData?.forEach((element) {
        venues.add(element);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getVenues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: venues.isEmpty
          ? const Text("There is no venue available.")
          : ListView.builder(
              itemCount: venues.length,
              itemBuilder: (context, int index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 30,
                        height: venues[index]["imageURL"] == null ? 50 : 310,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            venues[index]["imageURL"] == null
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width -
                                          60,
                                      height: 230,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: Colors.grey),
                                      ),
                                      child: Image.network(
                                        venues[index]["imageURL"],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                            Padding(
                              padding: const EdgeInsets.only(left: 9),
                              child: Text(venues[index]["Venue Name"]),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                );
              }),
    ));
  }
}
