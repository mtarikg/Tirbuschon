import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../Core/User/ReservationPages/selectDatePage.dart';
import '../Core/User/SearchPages/googleMaps.dart';
import '../Core/User/SearchPages/menuPage.dart';
import 'firestoreService.dart';

class UserService {
  Future<Position> getUserCurrentPosition() async {
    Position currentPosition;
    var result = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true);
    currentPosition = result;

    return currentPosition;
  }

  Future<List<String>> getUserCurrentAddressData() async {
    Position position = await getUserCurrentPosition();
    List<Placemark> p =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = p[0];
    List<String> currentAddressData = [];
    currentAddressData.add(place.administrativeArea.toString());
    currentAddressData.add(place.subAdministrativeArea.toString());

    return currentAddressData;
  }

  void showLocation(BuildContext context, var venue) {
    var address = venue["Address"];

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MapView(venueAddress: address)));
  }

  void showMenu(BuildContext context, var venue) async {
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

  void makeReservation(BuildContext context, var venue) async {
    var venueID =
        await FirestoreService().getVenueIDByName(venue["Venue Name"]);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectDate(venueID: venueID.toString())));
  }
}
