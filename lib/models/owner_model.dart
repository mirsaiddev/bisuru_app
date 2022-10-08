import 'package:bi_suru_app/models/comment_model.dart';
import 'package:bi_suru_app/models/product_model.dart';
import 'package:bi_suru_app/models/reference.dart';

class OwnerModel {
  String name;
  String phone;
  String email;
  String city;
  String district;
  String? uid, profilePicUrl;
  String? placeName, placeDescription, placeLongDescription, placePicture, contactInfo;
  List placePictures;
  Map? placeAddress;
  String? placeCategory;
  String? placeRealAddress;
  bool enable;
  final List products;
  final List references;
  final List comments;
  final bool isOwner;
  final String taxNumber;
  final String taxOffice;
  bool smsVerified;
  bool premium;

  List getImages() {
    List images = [placePicture];
    images.addAll(placePictures);
    return images;
  }

  bool placeIsOpen() {
    return placeName != null &&
        placeDescription != null &&
        placeAddress != null &&
        placePicture != null &&
        placeCategory != null &&
        placeLongDescription != null &&
        placeRealAddress != null &&
        contactInfo != null;
  }

  double getAverageRating() {
    double total = 0;
    for (CommentModel comment in comments) {
      total += comment.rating;
    }
    double result = total / comments.length;
    return result.isNaN ? 0 : result;
  }

  OwnerModel({
    required this.name,
    required this.phone,
    required this.email,
    required this.city,
    required this.district,
    required this.taxOffice,
    required this.taxNumber,
    this.uid,
    this.profilePicUrl,
    this.placeName,
    this.placeDescription,
    this.placeLongDescription,
    this.contactInfo,
    this.placeAddress,
    this.placePicture,
    this.placeCategory,
    this.placeRealAddress,
    this.placePictures = const [],
    required this.enable,
    required this.products,
    required this.comments,
    this.references = const [],
    this.isOwner = true,
    this.smsVerified = false,
    this.premium = false,
  });

  factory OwnerModel.fromJson(Map json) {
    return OwnerModel(
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      city: json['city'],
      district: json['district'],
      uid: json['uid'],
      profilePicUrl: json['profilePicUrl'],
      placeName: json['placeName'],
      placeDescription: json['placeDescription'],
      placeLongDescription: json['placeLongDescription'],
      contactInfo: json['contactInfo'],
      placeAddress: json['placeAddress'],
      placePicture: json['placePicture'],
      placeCategory: json['placeCategory'],
      placeRealAddress: json['placeRealAddress'],
      enable: json['enable'] ?? false,
      placePictures: json['placePictures'] != null ? (json['placePictures'].entries).map((e) => e.value).toList() : [],
      products: json['products'] != null ? (json['products'].entries).map((e) => ProductModel.fromMap(e.value)).toList() : [],
      references: json['references'] != null ? (json['references'].entries).map((e) => Reference.fromMap(e.value)).toList() : [],
      comments: json['comments'] != null ? (json['comments'].entries).map((e) => CommentModel.fromMap(e.value as Map)).toList() : [],
      isOwner: true,
      taxNumber: json['taxNumber'] ?? '',
      taxOffice: json['taxOffice'] ?? '',
      smsVerified: json['smsVerified'] ?? false,
      premium: json['premium'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'city': city,
      'district': district,
      'uid': uid,
      'profilePicUrl': profilePicUrl,
      'placeName': placeName,
      'placeDescription': placeDescription,
      'placeLongDescription': placeLongDescription,
      'placeRealAddress': placeRealAddress,
      'contactInfo': contactInfo,
      'placeAddress': placeAddress,
      'placePicture': placePicture,
      'placeCategory': placeCategory,
      'enable': enable,
      'products': products.map((e) => e.toJson()).toList(),
      'references': references,
      'isOwner': isOwner,
      'comments': comments.map((e) => e.toJson()).toList(),
      'taxNumber': taxNumber,
      'taxOffice': taxOffice,
      'smsVerified': smsVerified,
      'premium': premium,
    };
  }
}
