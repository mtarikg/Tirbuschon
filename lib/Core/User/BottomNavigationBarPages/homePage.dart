import 'package:flutter/material.dart';
import '../../../services/firestoreService.dart';
import '../../../services/userService.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(left: 10, top: 50),
      child: Column(
        children: [
          _venues(),
          _venuesNearby(),
        ],
      ),
    ));
  }

  Widget _venues() {
    return Row(
      children: const [
        Expanded(
          child: Align(
              alignment: Alignment.topLeft,
              child: Text("Restaurants Nearby:",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.topRight,
            child: TextButton(
                onPressed: null,
                child: Text(
                  "Show all",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                )),
          ),
        ),
      ],
    );
  }

  Widget _venuesNearby() {
    return FutureBuilder<List<dynamic>?>(
        future: getNearbyVenues(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, int index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Flexible(
                          child: Container(
                            width: MediaQuery.of(context).size.width - 30,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                snapshot.data![index]["imageURL"] == null
                                    ? const SizedBox()
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              60,
                                          height: 230,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1, color: Colors.grey),
                                          ),
                                          child: Image.network(
                                            snapshot.data![index]["imageURL"],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 9),
                                  child: Text(
                                      snapshot.data![index]["Venue Name"],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          UserService().showLocation(
                                              context, snapshot.data![index]);
                                        },
                                        child: const Text("Location")),
                                    TextButton(
                                        onPressed: () {
                                          UserService().showMenu(
                                              context, snapshot.data![index]);
                                        },
                                        child: const Text("Menu")),
                                    TextButton(
                                        onPressed: () {
                                          UserService().makeReservation(
                                              context, snapshot.data![index]);
                                        },
                                        child: const Text("Quick reservation")),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                });
          }

          return const Text("No venue nearby");
        });
  }

  Future<List<dynamic>?> getNearbyVenues() async {
    List<String> locationData;
    List? nearbyVenues;
    locationData = await UserService().getUserCurrentAddressData();
    nearbyVenues = await FirestoreService()
        .getVenuesByCityDistrict(locationData[0], locationData[1]);

    return nearbyVenues;
  }
}
