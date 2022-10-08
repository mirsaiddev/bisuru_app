import 'package:bi_suru_app/models/purchase.dart';

class UserModel {
  String fullName;
  String phone;
  String email;
  String city;
  String district;
  String? uid, profilePicUrl;
  List savedPlaces;
  final bool isOwner;
  final List purchases;
  bool premium;
  bool smsVerified;
  bool isDeleted;
  int points;

  UserModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.city,
    required this.district,
    this.uid,
    this.profilePicUrl,
    this.savedPlaces = const [],
    this.isOwner = false,
    this.purchases = const [],
    this.premium = false,
    this.smsVerified = false,
    this.isDeleted = false,
    this.points = 0,
  });

  factory UserModel.fromJson(Map json) {
    return UserModel(
      email: json['email'],
      uid: json['uid'],
      phone: json['phone'],
      fullName: json['fullName'],
      city: json['city'],
      district: json['district'],
      profilePicUrl: json['profilePicUrl'],
      savedPlaces: json['savedPlaces'] != null ? json['savedPlaces'].entries.map((e) => e.value).toList() : [],
      isOwner: json['isOwner'] ?? false,
      purchases: json['purchases'] != null ? (json['purchases'].entries).map((e) => Purchase.fromMap(e.value)).toList() : [],
      premium: json['premium'] ?? false,
      smsVerified: json['smsVerified'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      points: json['points'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'uid': uid,
      'city': city,
      'district': district,
      'profilePicUrl': profilePicUrl,
      'savedPlaces': savedPlaces,
      'isOwner': false,
      'purchases': purchases,
      'premium': premium,
      'smsVerified': smsVerified,
      'isDeleted': isDeleted,
      'points': points,
    };

    return result;
  }
}
