// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class MesajModel {
  final String kimden;
  final String kime;
  final Timestamp? date;
  final bool bendenMi;
  final String mesaj;

  MesajModel({
    required this.kimden,
    required this.kime,
    this.date,
    required this.bendenMi,
    required this.mesaj,
  });

 

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'kimden': kimden,
      'kime': kime,
      'date': date ?? FieldValue.serverTimestamp(),
      'bendenMi': bendenMi,
      'mesaj': mesaj,
    };
  }

  factory MesajModel.fromMap(Map<String, dynamic> map) {
    return MesajModel(
      kimden: map['kimden'] as String,
      kime: map['kime'] as String,
      date: map['date'] ,
      bendenMi: map['bendenMi'] as bool,
      mesaj: map['mesaj'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MesajModel.fromJson(String source) =>
      MesajModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MesajModel(kimden: $kimden, kime: $kime, date: $date, bendenMi: $bendenMi, mesaj: $mesaj)';
  }

  @override
  bool operator ==(covariant MesajModel other) {
    if (identical(this, other)) return true;

    return other.kimden == kimden &&
        other.kime == kime &&
        other.date == date &&
        other.bendenMi == bendenMi &&
        other.mesaj == mesaj;
  }

  @override
  int get hashCode {
    return kimden.hashCode ^
        kime.hashCode ^
        date.hashCode ^
        bendenMi.hashCode ^
        mesaj.hashCode;
  }
}
