import 'package:bi_suru_app/models/il_ilce_model.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/my_list_tile.dart';
import 'package:bi_suru_app/widgets/my_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectDistrictScreen extends StatefulWidget {
  final Il selectedCity;
  final Ilce? selectedDistrict;
  const SelectDistrictScreen({Key? key, required this.selectedCity, this.selectedDistrict}) : super(key: key);

  @override
  State<SelectDistrictScreen> createState() => _SelectDistrictScreenState(selectedDistrict);
}

class _SelectDistrictScreenState extends State<SelectDistrictScreen> {
  Ilce? selectedDistrict;

  _SelectDistrictScreenState(this.selectedDistrict);

  List searchedDistricts = [];
  bool searched = false;

  void searchCity(String text) {
    if (text.isEmpty || text == '' || text.length == 0) {
      searched = false;

      setState(() {});
      return;
    }
    searched = true;
    searchedDistricts = widget.selectedCity.ilceler.where((x) => x.ilceAdi.toLowerCase().contains(text.toLowerCase())).toList();
    setState(() {});
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
                action: selectedDistrict != null && widget.selectedDistrict == null ||
                        widget.selectedDistrict != null && selectedDistrict!.ilceAdi != widget.selectedDistrict!.ilceAdi
                    ? IconButton(
                        onPressed: () {
                          Navigator.pop(context, selectedDistrict);
                        },
                        icon: const Icon(Icons.check, color: MyColors.green),
                      )
                    : const SizedBox(),
              ),
              SizedBox(height: 10),
              MyListTile(
                child: MyTextfield(
                  fillColor: Colors.white,
                  hintText: 'İlçe Ara',
                  onChanged: (text) {
                    searchCity(text);
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: searched ? searchedDistricts.length : widget.selectedCity.ilceler.length,
                  itemBuilder: (context, index) {
                    Ilce district = searched ? searchedDistricts[index] : widget.selectedCity.ilceler[index];

                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: MyListTile(
                        padding: 16,
                        onTap: () {
                          setState(() {
                            selectedDistrict = district;
                          });
                        },
                        child: SizedBox(
                          height: 26,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 10),
                              Text('${index + 1}'),
                              SizedBox(width: 20),
                              Expanded(child: Text(district.ilceAdi)),
                              SizedBox(width: 20),
                              district == selectedDistrict
                                  ? const CircleAvatar(
                                      child: Padding(padding: EdgeInsets.all(2.0), child: Icon(Icons.check, color: Colors.white)),
                                      backgroundColor: MyColors.green)
                                  : const SizedBox(),
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
