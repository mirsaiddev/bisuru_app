import 'package:bi_suru_app/services/database_service.dart';
import 'package:flutter/material.dart';

class SystemProvider extends ChangeNotifier {
  List<String> sliders = [];
  List<String> categories = [];

  Future<void> getSliders() async {
    sliders = await DatabaseService().getSliders();
    notifyListeners();
  }

  Future<void> getCategories() async {
    categories = await DatabaseService().getCategories();
    notifyListeners();
  }
}
