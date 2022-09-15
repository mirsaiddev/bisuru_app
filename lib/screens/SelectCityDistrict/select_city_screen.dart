import 'dart:convert';

import 'package:bi_suru_app/models/il_ilce_model.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/my_list_tile.dart';
import 'package:bi_suru_app/widgets/my_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectCityScreen extends StatefulWidget {
  const SelectCityScreen({Key? key, this.selectedCity}) : super(key: key);

  final Il? selectedCity;

  @override
  State<SelectCityScreen> createState() => _SelectCityScreenState(selectedCity);
}

class _SelectCityScreenState extends State<SelectCityScreen> {
  List cities = [];

  Il? selectedCity;

  _SelectCityScreenState(this.selectedCity);

  Future<void> loadCityData() async {
    String jsonString = await rootBundle.loadString('lib/assets/json/il-ilce.json');

    final dynamic jsonResponse = json.decode(jsonString);

    setState(() {
      cities = jsonResponse.map((x) => Il.fromJson(x)).toList();
    });
  }

  List searchedCities = [];
  bool searched = false;

  void searchCity(String text) {
    if (text.isEmpty) {
      searched = false;
      setState(() {});
      return;
    }
    searched = true;
    searchedCities = cities.where((x) => x.ilAdi.toLowerCase().contains(text.toLowerCase())).toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadCityData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              MyAppBar(
                title: 'Şehir Seçiniz',
                showBackButton: true,
                action: selectedCity != null && widget.selectedCity == null || widget.selectedCity != null && selectedCity!.ilAdi != widget.selectedCity!.ilAdi
                    ? IconButton(
                        onPressed: () {
                          Navigator.pop(context, selectedCity);
                        },
                        icon: const Icon(Icons.check, color: MyColors.green),
                      )
                    : const SizedBox(),
              ),
              SizedBox(height: 10),
              MyListTile(
                child: MyTextfield(
                  fillColor: Colors.white,
                  hintText: 'Şehir Ara',
                  onChanged: (text) {
                    searchCity(text);
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: searched ? searchedCities.length : cities.length,
                  itemBuilder: (context, index) {
                    Il city = searched ? searchedCities[index] : cities[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: MyListTile(
                        padding: 16,
                        onTap: () {
                          setState(() {
                            selectedCity = city;
                          });
                        },
                        child: SizedBox(
                          height: 26,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 10),
                              Text(city.plakaKodu),
                              SizedBox(width: 20),
                              Expanded(child: Text(city.ilAdi)),
                              SizedBox(width: 20),
                              selectedCity != null && selectedCity!.ilAdi == city.ilAdi ? const Icon(Icons.check, color: MyColors.green) : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
