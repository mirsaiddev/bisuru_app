import 'dart:convert';

import 'package:flutter/foundation.dart';

class Campaign {
  final String id;
  final String campaignName;
  final String campaignImage;
  final DateTime startDate;
  final DateTime endDate;
  final List ownerModels;
  Campaign({
    required this.id,
    required this.campaignName,
    required this.campaignImage,
    required this.startDate,
    required this.endDate,
    required this.ownerModels,
  });

  Campaign copyWith({
    String? id,
    String? campaignName,
    String? campaignImage,
    DateTime? startDate,
    DateTime? endDate,
    List? ownerModels,
  }) {
    return Campaign(
      id: id ?? this.id,
      campaignName: campaignName ?? this.campaignName,
      campaignImage: campaignImage ?? this.campaignImage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      ownerModels: ownerModels ?? this.ownerModels,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'campaignName': campaignName});
    result.addAll({'campaignImage': campaignImage});
    result.addAll({'startDate': startDate.toString()});
    result.addAll({'endDate': endDate.toString()});
    result.addAll({'ownerModels': ownerModels});

    return result;
  }

  factory Campaign.fromMap(Map<dynamic, dynamic> map) {
    return Campaign(
      id: map['id'],
      campaignName: map['campaignName'] ?? '',
      campaignImage: map['campaignImage'] ?? '',
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      ownerModels: map['ownerModels'] != null ? map['ownerModels'].entries.map((e) => e.value).toList() : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Campaign.fromJson(String source) => Campaign.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Campaign(id: $id, campaignName: $campaignName, campaignImage: $campaignImage, startDate: $startDate, endDate: $endDate, ownerModels: $ownerModels)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Campaign &&
        other.id == id &&
        other.campaignName == campaignName &&
        other.campaignImage == campaignImage &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        listEquals(other.ownerModels, ownerModels);
  }

  @override
  int get hashCode {
    return id.hashCode ^ campaignName.hashCode ^ campaignImage.hashCode ^ startDate.hashCode ^ endDate.hashCode ^ ownerModels.hashCode;
  }
}
