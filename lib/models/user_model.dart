class UserModel {
  String fullName;
  String phone;
  String email;
  String city;
  String district;
  String? uid, profilePicUrl;
  List savedPlaces;
  final bool isOwner;

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
    };

    return result;
  }
}
