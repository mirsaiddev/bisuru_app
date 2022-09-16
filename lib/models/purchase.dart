import 'dart:convert';

class Purchase {
  final String ownerUid;
  final DateTime date;
  final String productName;
  Purchase({
    required this.ownerUid,
    required this.date,
    required this.productName,
  });

  Purchase copyWith({
    String? name,
    DateTime? date,
    String? productName,
  }) {
    return Purchase(
      ownerUid: name ?? this.ownerUid,
      date: date ?? this.date,
      productName: productName ?? this.productName,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': ownerUid});
    result.addAll({'date': date.millisecondsSinceEpoch});
    result.addAll({'productName': productName});

    return result;
  }

  factory Purchase.fromMap(Map<dynamic, dynamic> map) {
    return Purchase(
      ownerUid: map['name'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      productName: map['productName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Purchase.fromJson(String source) => Purchase.fromMap(json.decode(source));

  @override
  String toString() => 'Purchase(name: $ownerUid, date: $date, productName: $productName)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Purchase && other.ownerUid == ownerUid && other.date == date && other.productName == productName;
  }

  @override
  int get hashCode => ownerUid.hashCode ^ date.hashCode ^ productName.hashCode;
}
