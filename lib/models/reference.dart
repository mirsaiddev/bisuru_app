import 'dart:convert';

class Reference {
  final String uid;
  final DateTime date;
  final String productName;
  Reference({
    required this.uid,
    required this.date,
    required this.productName,
  });

  Reference copyWith({
    String? name,
    DateTime? date,
    String? productName,
  }) {
    return Reference(
      uid: name ?? this.uid,
      date: date ?? this.date,
      productName: productName ?? this.productName,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': uid});
    result.addAll({'date': date.millisecondsSinceEpoch});
    result.addAll({'productName': productName});

    return result;
  }

  factory Reference.fromMap(Map<dynamic, dynamic> map) {
    return Reference(
      uid: map['name'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      productName: map['productName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Reference.fromJson(String source) => Reference.fromMap(json.decode(source));

  @override
  String toString() => 'Reference(name: $uid, date: $date, productName: $productName)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Reference && other.uid == uid && other.date == date && other.productName == productName;
  }

  @override
  int get hashCode => uid.hashCode ^ date.hashCode ^ productName.hashCode;
}
