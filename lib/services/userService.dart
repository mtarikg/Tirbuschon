import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../Core/User/ReservationPages/selectDatePage.dart';
import '../Core/User/SearchPages/googleMaps.dart';
import '../Core/User/SearchPages/menuPage.dart';
import '../Core/User/SearchPages/viewVenue.dart';
import 'firestoreService.dart';

class UserService {
  Future<Position> getUserCurrentPosition() async {
    Position currentPosition;
    var result = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
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

  void viewDetails(BuildContext context, String venueName) async {
    var venueID = await FirestoreService().getVenueIDByName(venueName);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewVenue(venueID: venueID.toString())));
  }
}
