import 'package:flutter/material.dart';
import '../SearchPages/googleMaps.dart';
import '../../../services/firestoreService.dart';
import '../SearchPages/menuPage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var venues = [];
  var test = [];
  String searchValue = '';
  String venueType = '';
  String districtValue = '';
  String cityValue = '';
  TextEditingController searchController = TextEditingController();

  getVenues() async {
    var venuesData = await FirestoreService().getAllVenues();

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
            child: Column(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: _searchTextField(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: _venueTypeDropdown(),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: _cityDropdown(),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: _districtDropdown(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Expanded(
                  child: ListView.builder(
                      itemCount: venues.length,
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
                                      venues[index]["imageURL"] == null
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
                                                  venues[index]["imageURL"],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 9),
                                        child: Text(venues[index]["Venue Name"],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                _showLocation(venues[index]);
                                              },
                                              child: const Text("Show location")),
                                          TextButton(
                                              onPressed: () {
                                                _showMenu(venues[index]);
                                              },
                                              child: const Text("Show menu!")),
                                          TextButton(
                                              onPressed: () {
                                                _makeReservation();
                                              },
                                              child:
                                                  const Text("Make a reservation!")),
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
                      }),
                ),
              ],
            )));
  }

  DropdownButtonFormField<String> _venueTypeDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'Venue Type'),
      value: null,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: (String? newValue) {
        setState(() {
          venueType = newValue!;
        });
      },
      items: <String>['Activity', 'Restaurant']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  DropdownButtonFormField<String> _cityDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'City'),
      value: null,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: (String? newValue) {
        setState(() {
          venueType = newValue!;
        });
      },
      items: <String>['Activity', 'Restaurant']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  DropdownButtonFormField<String> _districtDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'District'),
      value: null,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: (String? newValue) {
        setState(() {
          venueType = newValue!;
        });
      },
      items: <String>['Activity', 'Restaurant']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  TextField _searchTextField() {
    return TextField(
      decoration: InputDecoration(
        suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _searchVenueByName(searchValue);
            }),
        labelText: "Search venues",
        hintText: "Please enter name of a venue",
      ),
      onChanged: (value) {
        setState(() {
          searchValue = value.toString();
        });
      },
    );
  }

  void _showLocation(var venue) {
    var address = venue["Address"];

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MapView(venueAddress: address)));
  }

  void _showMenu(var venue) async {
    var venueID = await FirestoreService().getVenueByName(venue["Venue Name"]);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MenuPage(
                  venueName: venue["Venue Name"],
                  venueID: venueID.toString(),
                )));
  }

  void _makeReservation() {}

  Future<void> _searchVenueByName(String value) async {}
}
