import 'package:bi_suru_app/models/comment_model.dart';
import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/models/product_model.dart';
import 'package:bi_suru_app/models/reference.dart';
import 'package:bi_suru_app/models/responses/get_user_response.dart';
import 'package:bi_suru_app/models/user_model.dart';
import 'package:bi_suru_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseService() {
    firebaseDatabase.databaseURL = 'https://bisuru-8da3c-default-rtdb.europe-west1.firebasedatabase.app/';
  }

  Future<void> createNewUserModel({required UserModel userModel}) async {
    await firebaseDatabase.ref().child('users').child(userModel.uid!).set(userModel.toJson()).catchError((error) => debugPrint('error : $error'));
  }

  Future<void> createNewOwnerModel({required OwnerModel ownerModel}) async {
    await firebaseDatabase.ref().child('owners').child(ownerModel.uid!).set(ownerModel.toJson()).catchError((error) => debugPrint('error : $error'));
  }

  Future<UserModel?> getUserModel() async {
    User? user = AuthService().getUser();
    if (user == null) {
      return null;
    }
    DataSnapshot dataSnapshot = await firebaseDatabase.ref().child('users').child(user.uid).get();
    if (!dataSnapshot.exists) {
      return null;
    }

    return UserModel.fromJson(dataSnapshot.value as Map);
  }

  Future<OwnerModel?> getOwnerModel() async {
    User? user = AuthService().getUser();
    if (user == null) {
      return null;
    }
    DataSnapshot dataSnapshot = await firebaseDatabase.ref().child('owners').child(user.uid).get();
    if (!dataSnapshot.exists) {
      return null;
    }

    return OwnerModel.fromJson(dataSnapshot.value as Map);
  }

  Future<void> updateOwnerData({required String ownerId, required Map<String, dynamic> data}) async {
    await firebaseDatabase.ref().child('owners').child(ownerId).update(data);
  }

  Future<void> updateUserData({required String userId, required Map<String, dynamic> data}) async {
    await firebaseDatabase.ref().child('users').child(userId).update(data);
  }

  Future<List<String>> getSliders() async {
    DataSnapshot dataSnapshot = await firebaseDatabase.ref().child('system').child('sliders').get();
    List<dynamic> sliders = (dataSnapshot.value as List).map((e) => e != null ? e.toString() : e).toList();
    return sliders.where((element) => element != null).toList().map((e) => e.toString()).toList();
  }

  Future<List<String>> getCategories() async {
    DataSnapshot dataSnapshot = await firebaseDatabase.ref().child('system').child('categories').get();
    List<dynamic> sliders = (dataSnapshot.value as List).map((e) => e != null ? e.toString() : e).toList();
    return sliders.where((element) => element != null).toList().map((e) => e.toString()).toList();
  }

  Future<void> createProduct({required String ownerUid, required ProductModel productModel}) async {
    await firebaseDatabase.ref().child('owners').child(ownerUid).child('products').push().set(productModel.toMap());
  }

  Future<void> editProductModel({required String ownerUid, required ProductModel productModel}) async {
    DataSnapshot dataSnapshot = await firebaseDatabase.ref().child('owners').child(ownerUid).child('products').get();
    if (dataSnapshot.exists) {
      Map productsMap = dataSnapshot.value as Map;
      MapEntry product = productsMap.entries.firstWhere((element) => element.value['id'] == productModel.id);
      await firebaseDatabase.ref().child('owners').child(ownerUid).child('products').child(product.key).update(productModel.toMap());
    }
  }

  Future<void> deleteProduct({required String ownerUid, required ProductModel productModel}) async {
    DataSnapshot dataSnapshot = await firebaseDatabase.ref().child('owners').child(ownerUid).child('products').get();
    if (dataSnapshot.exists) {
      Map productsMap = dataSnapshot.value as Map;
      MapEntry product = productsMap.entries.firstWhere((element) => element.value['id'] == productModel.id);
      await firebaseDatabase.ref().child('owners').child(ownerUid).child('products').child(product.key).remove();
    }
  }

  Future<ProductModel> getProduct({required String ownerUid, required String productId}) async {
    DataSnapshot dataSnapshot = await firebaseDatabase.ref().child('owners').child(ownerUid).child('products').child(productId).get();
    return ProductModel.fromMap(dataSnapshot.value as Map);
  }

  Stream<DatabaseEvent> productsStream(String ownerUid) {
    Stream<DatabaseEvent> stream = firebaseDatabase.ref().child('owners').child(ownerUid).child('products').onValue;
    return stream;
  }

  Stream<DatabaseEvent> referencesStream(String ownerUid) {
    Stream<DatabaseEvent> stream = firebaseDatabase.ref().child('owners').child(ownerUid).child('references').onValue;
    return stream;
  }

  Future<List<OwnerModel>> getAllOwnerModels(String city) async {
    DataSnapshot dataSnapshot = await firebaseDatabase.ref().child('owners').orderByChild('city').equalTo(city).get();
    Map ownersMap = dataSnapshot.value as Map;
    List<OwnerModel> owners = ownersMap.entries.map((e) => OwnerModel.fromJson(e.value as Map)).toList();
    return owners;
  }

  Stream<DatabaseEvent> ownerModelStream(String ownerId) {
    return firebaseDatabase.ref().child('owners').child(ownerId).onValue;
  }

  Future<void> savePlace(String uid, String ownerUid) async {
    await firebaseDatabase.ref().child('users').child(uid).child('savedPlaces').push().set(ownerUid);
  }

  Future<void> removeSavedPlace(String uid, String ownerUid) async {
    DataSnapshot dataSnapshot = await firebaseDatabase.ref().child('users').child(uid).child('savedPlaces').get();
    Map savedPlaces = dataSnapshot.value as Map;
    String? key = savedPlaces.entries.firstWhere((element) => element.value == ownerUid, orElse: () => MapEntry('', '')).key;
    if (key != null && key.isNotEmpty) {
      await firebaseDatabase.ref().child('users').child(uid).child('savedPlaces').child(key).remove();
    }
  }

  Stream<DatabaseEvent> savedPlacesStream(String uid) {
    return firebaseDatabase.ref().child('users').child(uid).child('savedPlaces').onValue;
  }

  Future<OwnerModel> getOwnerModelById(String ownerId) async {
    DataSnapshot dataSnapshot = await firebaseDatabase.ref().child('owners').child(ownerId).get();

    return OwnerModel.fromJson(dataSnapshot.value as Map);
  }

  Future<void> addReferences({required Reference reference, required String ownerUid}) async {
    await firebaseDatabase.ref().child('owners').child(ownerUid).child('references').push().set(reference.toMap());
  }

  Stream<DatabaseEvent> userStream(String uid) {
    return firebaseDatabase.ref().child('users').child(uid).onValue;
  }

  Future<void> addComment(String ownerUid, CommentModel comment) async {
    await firebaseDatabase.ref().child('owners').child(ownerUid).child('comments').push().set(comment.toMap());
  }
}
