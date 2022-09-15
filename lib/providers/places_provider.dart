import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:flutter/material.dart';

class PlacesProvider extends ChangeNotifier {
  List<OwnerModel> places = [];
  bool placesGet = false;

  Future<void> getAllPlaces(String city) async {
    if (placesGet) {
      return;
    }
    List<OwnerModel> _places = await DatabaseService().getAllOwnerModels(city);
    places = _places.where((element) => element.placeIsOpen()).toList();
    placesGet = true;
    notifyListeners();
  }

  int getPlaceCountForCategory(String category) {
    return places.where((element) => element.placeCategory == category).length;
  }

  List<OwnerModel> getPlacesForCategory(String category) {
    return places.where((element) => element.placeCategory == category).toList();
  }
}
