import 'dart:convert';

class CommentModel {
  String comment;
  String senderName;
  int rating;
  DateTime createDate;
  CommentModel({
    required this.comment,
    required this.senderName,
    required this.rating,
    required this.createDate,
  });

  CommentModel copyWith({
    String? comment,
    String? senderName,
    int? rating,
    DateTime? createDate,
  }) {
    return CommentModel(
      comment: comment ?? this.comment,
      senderName: senderName ?? this.senderName,
      rating: rating ?? this.rating,
      createDate: createDate ?? this.createDate,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'comment': comment});
    result.addAll({'senderName': senderName});
    result.addAll({'rating': rating});
    result.addAll({'createDate': createDate.millisecondsSinceEpoch});

    return result;
  }

  factory CommentModel.fromMap(Map<dynamic, dynamic> map) {
    return CommentModel(
      comment: map['comment'] ?? '',
      senderName: map['senderName'] ?? '',
      rating: map['rating']?.toInt() ?? 0,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) => CommentModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CommentModel(comment: $comment, senderName: $senderName, rating: $rating, createDate: $createDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CommentModel && other.comment == comment && other.senderName == senderName && other.rating == rating && other.createDate == createDate;
  }

  @override
  int get hashCode {
    return comment.hashCode ^ senderName.hashCode ^ rating.hashCode ^ createDate.hashCode;
  }
}
