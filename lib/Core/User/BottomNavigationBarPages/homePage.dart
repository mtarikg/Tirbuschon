import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../services/firestoreService.dart';
import '../../Shared/userService.dart';
import 'mainPage.dart';

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
        body: RefreshIndicator(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 50,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, top: 50),
            child: Column(
              children: [
                _venuesNearbyText(),
                _venuesNearby(),
                const SizedBox(height: 30),
                _latestReservationsText(),
                _latestReservations()
              ],
            ),
          ),
        ),
      ),
      onRefresh: _refreshHome,
    ));
  }

  Widget _venuesNearbyText() {
    return Row(
      children: [
        const Expanded(
          child: Align(
              alignment: Alignment.topLeft,
              child: Text("Restaurants Nearby:",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.topRight,
            child: TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainPage(index: 1)),
                      (route) => false);
                },
                child: const Text(
                  "All restaurants",
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
            return SizedBox(
              height: 125,
              child: Align(
                alignment: Alignment.centerLeft,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length.clamp(0, 10),
                    itemBuilder: (context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 7.5),
                        child: InkWell(
                          onTap: () {
                            UserService().viewDetails(
                                context, snapshot.data![index]["Venue Name"]);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              snapshot.data![index]["imageURL"] == null
                                  ? const SizedBox(width: 100, height: 100)
                                  : Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5, color: Colors.grey),
                                      ),
                                      child: Image.network(
                                        snapshot.data![index]["imageURL"],
                                        fit: BoxFit.cover,
                                      )),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(snapshot.data![index]["Venue Name"],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10)),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            );
          }

          return const Text("No venue nearby");
        });
  }

  Widget _latestReservationsText() {
    return Row(
      children: [
        const Expanded(
          child: Align(
              alignment: Alignment.topLeft,
              child: Text("Your latest reservations:",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.topRight,
            child: TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainPage(index: 2)),
                      (route) => false);
                },
                child: const Text(
                  "All reservations",
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

  Widget _latestReservations() {
    return StreamBuilder(
        stream: FirestoreService().getUserReservations(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            return SizedBox(
              height: 100,
              child: Align(
                alignment: Alignment.centerLeft,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length.clamp(0, 10),
                    itemBuilder: (context, int index) {
                      var snapshotDocs = snapshot.data!.docs;
                      return Padding(
                        padding: const EdgeInsets.only(right: 7.5),
                        child: InkWell(
                          onTap: () {
                            UserService().reservationDetail(
                                context, snapshotDocs[index]);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0.5, color: Colors.grey),
                                  ),
                                  child: Image.asset(
                                      'assets/placeholder-restaurant-300x300.png')),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            );
          }

          return const Text("No reservations made yet!");
        });
  }

  Future<List<dynamic>?> getNearbyVenues() async {
    List<String> locationData;
    List? nearbyVenues;

    var enabled = await Geolocator.isLocationServiceEnabled();
    if (enabled) {
      locationData = await UserService().getUserCurrentAddressData();
      nearbyVenues = await FirestoreService()
          .getVenuesByCityDistrict(locationData[0], locationData[1]);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Enable the location and reload the page!"),
      ));
    }

    return nearbyVenues;
  }

  Future<void> _refreshHome() async {
    Navigator.pop(context);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainPage(index: 0)),
        (route) => false);
  }
}
