import 'package:bi_suru_app/providers/system_provider.dart';
import 'package:bi_suru_app/theme/colors.dart';
import 'package:bi_suru_app/widgets/my_app_bar.dart';
import 'package:bi_suru_app/widgets/my_list_tile.dart';
import 'package:bi_suru_app/widgets/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectCategory extends StatefulWidget {
  const SelectCategory({Key? key}) : super(key: key);

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  String? selectedCategory;
  List<String> categories = [];
  List<String> searchedCategories = [];
  bool searched = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getCategories();
    });
  }

  Future<void> getCategories() async {
    SystemProvider systemProvider = Provider.of<SystemProvider>(context, listen: false);
    if (systemProvider.categories.isEmpty) {
      await systemProvider.getCategories();
    }
    categories = systemProvider.categories;
    setState(() {});
  }

  void search(String text) {
    if (text.isEmpty) {
      searched = false;
      setState(() {});
      return;
    }
    searched = true;
    searchedCategories = categories.where((x) => x.toLowerCase().contains(text.toLowerCase())).toList();
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
                title: 'Kategoriy Seçiniz',
                showBackButton: true,
                action: selectedCategory != null
                    ? IconButton(
                        onPressed: () {
                          Navigator.pop(context, selectedCategory);
                        },
                        icon: const Icon(Icons.check, color: MyColors.green),
                      )
                    : const SizedBox(),
              ),
              SizedBox(height: 10),
              MyListTile(
                child: MyTextfield(
                  fillColor: Colors.white,
                  hintText: 'Kategori Ara',
                  onChanged: (text) {
                    search(text);
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: searched ? searchedCategories.length : categories.length,
                  itemBuilder: (context, index) {
                    String category = searched ? searchedCategories[index] : categories[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: MyListTile(
                        padding: 16,
                        onTap: () {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                        child: SizedBox(
                          height: 26,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 10),
                              Text(category),
                              SizedBox(width: 20),
                              Spacer(),
                              selectedCategory != null && selectedCategory == category ? const Icon(Icons.check, color: MyColors.green) : const SizedBox(),
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
