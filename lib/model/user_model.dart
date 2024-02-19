// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  String email;
  String? userName;
  String? profilUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? seviye;
  UserModel({
    required this.userId,
    required this.email,
    this.userName,
    this.profilUrl,
    this.createdAt,
    this.updatedAt,
    this.seviye,
  });

  UserModel copyWith({
    String? userId,
    String? email,
    String? userName,
    String? profilUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? seviye,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      profilUrl: profilUrl ?? this.profilUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      seviye: seviye ?? this.seviye,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'email': email,
      'userName':
          userName ?? email.substring(0, email.indexOf("@")) + randomSayi(),
      'profilUrl': profilUrl ??
          "https://emrealtunbilek.com/wp-content/uploads/2016/10/apple-icon-72x72.png",
      'createdAt':
          createdAt?.millisecondsSinceEpoch ?? FieldValue.serverTimestamp(),
      'updatedAt':
          updatedAt?.millisecondsSinceEpoch ?? FieldValue.serverTimestamp(),
      'seviye': seviye ?? 1,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
  return UserModel(
    userId: map['userId'] as String,
    email: map['email'] as String,
    userName: map['userName'] as String?,
    profilUrl: map['profilUrl'] as String?,
    createdAt: map['createdAt'] != null
        ? (map['createdAt'] as Timestamp).toDate()
        : null,
    updatedAt: map['updatedAt'] != null
        ? (map['updatedAt'] as Timestamp).toDate()
        : null,
    seviye: map['seviye'] as int?,
  );
}


  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(userId: $userId, email: $email, userName: $userName, profilUrl: $profilUrl, createdAt: $createdAt, updatedAt: $updatedAt, seviye: $seviye)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.email == email &&
        other.userName == userName &&
        other.profilUrl == profilUrl &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.seviye == seviye;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        email.hashCode ^
        userName.hashCode ^
        profilUrl.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        seviye.hashCode;
  }

  String randomSayi() {
    int randomGelenSayi = Random().nextInt(999999);
    return randomGelenSayi.toString();
  }
}
