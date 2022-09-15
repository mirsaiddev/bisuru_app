import 'dart:convert';

import 'package:flutter/foundation.dart';

class ProductModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final double comission;
  final String image;
  final List comments;
  final String ownerUid;
  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.comission,
    required this.image,
    required this.comments,
    required this.ownerUid,
  });

  ProductModel copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    double? comission,
    String? image,
    List? comments,
    String? ownerUid,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      comission: comission ?? this.comission,
      image: image ?? this.image,
      comments: comments ?? this.comments,
      ownerUid: ownerUid ?? this.ownerUid,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'description': description});
    result.addAll({'price': price});
    result.addAll({'comission': comission});
    result.addAll({'image': image});
    result.addAll({'comments': comments});
    result.addAll({'ownerUid': ownerUid});

    return result;
  }

  factory ProductModel.fromMap(Map<dynamic, dynamic> map) {
    return ProductModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      comission: map['comission']?.toDouble() ?? 0.0,
      image: map['image'] ?? '',
      comments: List.from(map['comments'] ?? []),
      ownerUid: map['ownerUid'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, description: $description, price: $price, comission: $comission, image: $image, comments: $comments, ownerUid: $ownerUid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductModel &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.price == price &&
        other.comission == comission &&
        other.image == image &&
        listEquals(other.comments, comments) &&
        other.ownerUid == ownerUid;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ description.hashCode ^ price.hashCode ^ comission.hashCode ^ image.hashCode ^ comments.hashCode ^ ownerUid.hashCode;
  }
}
