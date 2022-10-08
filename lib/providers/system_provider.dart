import 'package:bi_suru_app/models/campaign.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:flutter/material.dart';

class SystemProvider extends ChangeNotifier {
  List<String> sliders = [];
  List<String> categories = [];
  List<Campaign> campaigns = [];
  int freePurchaseCount = 50;
  double userPremium1MonthPrice = 0;
  double userPremium3MonthPrice = 0;
  double ownerPremium1MonthPrice = 0;
  double ownerPremium3MonthPrice = 0;

  Future<void> getSliders() async {
    sliders = await DatabaseService().getSliders();
    notifyListeners();
  }

  Future<void> getCategories() async {
    categories = await DatabaseService().getCategories();
    notifyListeners();
  }

  Future<void> getCampaigns() async {
    campaigns = await DatabaseService().getCampaigns();
    notifyListeners();
  }

  Future<void> getFreePurchaseCount() async {
    freePurchaseCount = await DatabaseService().getFreePurchaseCount();
    notifyListeners();
  }

  Future<void> getPrices() async {
    Map prices = await DatabaseService().getPrices();
    userPremium1MonthPrice = prices['userPremium1MonthPrice'];
    userPremium3MonthPrice = prices['userPremium3MonthPrice'];
    ownerPremium1MonthPrice = prices['ownerPremium1MonthPrice'];
    ownerPremium3MonthPrice = prices['ownerPremium3MonthPrice'];
    notifyListeners();
  }
}
