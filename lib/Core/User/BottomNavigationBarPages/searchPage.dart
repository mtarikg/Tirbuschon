import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import '../ReservationPages/selectDatePage.dart';
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
  var searchResult = [];
  String searchValue = '';
  String venueType = '';
  String countryValue = '';
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
                    child: CSCPicker(
                      showStates: true,
                      showCities: true,
                      flagState: CountryFlag.DISABLE,
                      dropdownDecoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                          border: Border.all(
                              color: Colors.grey.shade300, width: 1)),
                      disabledDropdownDecoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: Colors.grey.shade300,
                          border: Border.all(
                              color: Colors.grey.shade300, width: 1)),
                      stateSearchPlaceholder: "City",
                      citySearchPlaceholder: "District",
                      stateDropdownLabel: "*City",
                      cityDropdownLabel: "*District",
                      defaultCountry: DefaultCountry.Turkey,
                      disableCountry: true,
                      selectedItemStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      dropdownHeadingStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                      dropdownItemStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      dropdownDialogRadius: 10.0,
                      searchBarRadius: 10.0,
                      onCountryChanged: (value) {
                        setState(() {
                          countryValue = value.toString();
                        });
                      },
                      onStateChanged: (value) {
                        setState(() {
                          cityValue = value
                              .toString()
                              .replaceAll(" ", "")
                              .replaceAll("Province", "")
                              .toString();
                        });
                      },
                      onCityChanged: (value) {
                        setState(() {
                          districtValue = value
                              .toString()
                              .replaceAll(" ", "")
                              .replaceAll("İlçesi", "")
                              .toString();
                        });
                      },
                    ),
                  ),
                ),
                Column(
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            cityValue = "";
                            districtValue = "";
                          });
                        },
                        child: const Text("Clear")),
                    TextButton(
                        onPressed: () {
                          _searchVenueByCityDistrict(cityValue, districtValue);
                        },
                        child: const Text("Search")),
                  ],
                )
              ],
            ),
          ],
        ),
        const SizedBox(height: 25),
        Expanded(
          child: searchResult.isEmpty
              ? ListView.builder(
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
                                border:
                                    Border.all(width: 1, color: Colors.grey),
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
                                          child: const Text("Location")),
                                      TextButton(
                                          onPressed: () {
                                            _showMenu(venues[index]);
                                          },
                                          child: const Text("Menu")),
                                      TextButton(
                                          onPressed: () {
                                            _makeReservation(venues[index]);
                                          },
                                          child:
                                              const Text("Quick reservation")),
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
                  })
              : ListView.builder(
                  itemCount: searchResult.length,
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
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  searchResult[index]["imageURL"] == null
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
                                              searchResult[index]["imageURL"],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 9),
                                    child: Text(
                                        searchResult[index]["Venue Name"],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            _showLocation(searchResult[index]);
                                          },
                                          child: const Text("Location")),
                                      TextButton(
                                          onPressed: () {
                                            _showMenu(searchResult[index]);
                                          },
                                          child: const Text("Menu")),
                                      TextButton(
                                          onPressed: () {
                                            _makeReservation(
                                                searchResult[index]);
                                          },
                                          child:
                                              const Text("Quick reservation")),
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
    var venueID =
        await FirestoreService().getVenueIDByName(venue["Venue Name"]);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MenuPage(
                  venueName: venue["Venue Name"],
                  venueID: venueID.toString(),
                )));
  }

  void _makeReservation(var venue) async {
    var venueID =
        await FirestoreService().getVenueIDByName(venue["Venue Name"]);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectDate(venueID: venueID.toString())));
  }

  Future<void> _searchVenueByName(String value) async {
    var result = await FirestoreService().getVenuesByName(value);

    result?.forEach((element) {
      var isExist = false;

      for (var item in searchResult) {
        if (item["Address"] == element["Address"]) {
          isExist = true;
          break;
        }
      }

      if (!isExist) {
        setState(() {
          searchResult.clear();
          searchResult.add(element);
        });
      }
    });
  }

  Future<void> _searchVenueByCityDistrict(String city, String district) async {
    searchResult.clear();
    var result =
        await FirestoreService().getVenuesByCityDistrict(city, district);

    if (result != null) {
      for (var element in result) {
        var isExist = false;

        for (var item in searchResult) {
          if (item["Address"] == element["Address"]) {
            isExist = true;
            break;
          }
        }

        if (!isExist) {
          setState(() {
            searchResult.add(element);
          });
        }
      }
    } else {
      setState(() {
        searchResult.clear();
      });
    }
  }
}
