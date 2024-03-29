import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/models/product_model.dart';
import 'package:bi_suru_app/models/reference.dart';
import 'package:bi_suru_app/models/user_model.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:bi_suru_app/utils/enums/auth_status.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  OwnerModel? ownerModel;
  UserModel? userModel;
  AuthStatus authStatus = AuthStatus.notLoggedIn;

  void setAuthStatus(AuthStatus newAuthStatus) {
    authStatus = newAuthStatus;
    notifyListeners();
  }

  void setOwnerModel(OwnerModel newOwnerModel) {
    ownerModel = newOwnerModel;
    notifyListeners();
  }

  void setUserModel(UserModel? newUserModel) {
    userModel = newUserModel;
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }

  Future<void> updateOwnerModel() async {
    ownerModel = await DatabaseService().getOwnerModel();
    notifyListeners();
  }

  Future<void> updatUserModel() async {
    userModel = await DatabaseService().getUserModel();
    notifyListeners();
  }

  Future<void> addReference({required String userId, required ProductModel productModel}) async {
    await updateOwnerModel();

    Reference reference = Reference(
      uid: userId,
      productModel: productModel,
      date: DateTime.now(),
    );
    ownerModel!.references.add(userId);
    await DatabaseService().addReferences(reference: reference, ownerUid: ownerModel!.uid!);
    notifyListeners();
  }
}
