import 'dart:convert';

import 'package:bi_suru_app/models/product_model.dart';

class Reference {
  final String uid;
  final DateTime date;
  final ProductModel productModel;
  Reference({
    required this.uid,
    required this.date,
    required this.productModel,
  });

  Reference copyWith({
    String? uid,
    DateTime? date,
    ProductModel? productModel,
  }) {
    return Reference(
      uid: uid ?? this.uid,
      date: date ?? this.date,
      productModel: productModel ?? this.productModel,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'uid': uid});
    result.addAll({'date': date.millisecondsSinceEpoch});
    result.addAll({'productModel': productModel.toMap()});

    return result;
  }

  factory Reference.fromMap(Map<dynamic, dynamic> map) {
    return Reference(
      uid: map['uid'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      productModel: ProductModel.fromMap(map['productModel']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Reference.fromJson(String source) => Reference.fromMap(json.decode(source));

  @override
  String toString() => 'Reference(uid: $uid, date: $date, productModel: $productModel)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Reference && other.uid == uid && other.date == date && other.productModel == productModel;
  }

  @override
  int get hashCode => uid.hashCode ^ date.hashCode ^ productModel.hashCode;
}
