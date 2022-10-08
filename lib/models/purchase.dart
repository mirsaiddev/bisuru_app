import 'dart:convert';

import 'package:bi_suru_app/models/product_model.dart';

class Purchase {
  final String ownerUid;
  final DateTime date;
  final ProductModel productModel;
  Purchase({
    required this.ownerUid,
    required this.date,
    required this.productModel,
  });

  Purchase copyWith({
    String? ownerUid,
    DateTime? date,
    ProductModel? productModel,
  }) {
    return Purchase(
      ownerUid: ownerUid ?? this.ownerUid,
      date: date ?? this.date,
      productModel: productModel ?? this.productModel,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'ownerUid': ownerUid});
    result.addAll({'date': date.millisecondsSinceEpoch});
    result.addAll({'productModel': productModel.toMap()});

    return result;
  }

  factory Purchase.fromMap(Map<dynamic, dynamic> map) {
    return Purchase(
      ownerUid: map['ownerUid'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      productModel: ProductModel.fromMap(map['productModel']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Purchase.fromJson(String source) => Purchase.fromMap(json.decode(source));

  @override
  String toString() => 'Purchase(ownerUid: $ownerUid, date: $date, productModel: $productModel)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Purchase && other.ownerUid == ownerUid && other.date == date && other.productModel == productModel;
  }

  @override
  int get hashCode => ownerUid.hashCode ^ date.hashCode ^ productModel.hashCode;
}
