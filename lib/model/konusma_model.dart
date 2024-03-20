import 'package:cloud_firestore/cloud_firestore.dart';
class KonusmaModel {
  final String konusma_sahibi;
  final String kimle_konusuyor;
  final bool goruldu;
  final Timestamp olusturulma_tarihi;
  final String son_yollanan_mesaj;
  final Timestamp son_gorulme;
  String? konusulanUserName; // Bu alan artık isteğe bağlı
  String? konusulanUserProfilUrl; // Bu alan artık isteğe bağlı
  DateTime? son_okuma_zamani;
  String? saat_farki;

  KonusmaModel({
    required this.konusma_sahibi,
    required this.kimle_konusuyor,
    required this.goruldu,
    required this.olusturulma_tarihi,
    required this.son_yollanan_mesaj,
    required this.son_gorulme,
    this.konusulanUserName, // Zorunlu olmaktan çıkarıldı
    this.konusulanUserProfilUrl, // Zorunlu olmaktan çıkarıldı
  });

  Map<String, dynamic> toMap() {
    return {
      'konusma_sahibi': konusma_sahibi,
      'kimle_konusuyor': kimle_konusuyor,
      'goruldu': goruldu,
      'olusturulma_tarihi': olusturulma_tarihi,
      'son_yollanan_mesaj': son_yollanan_mesaj,
      'son_gorulme': son_gorulme,
      'konusulanUserName': konusulanUserName,
      'konusulanUserProfilUrl': konusulanUserProfilUrl,
    };
  }

  factory KonusmaModel.fromMap(Map<String, dynamic> map) {
    return KonusmaModel(
      konusma_sahibi: map['konusma_sahibi'] ?? '',
      kimle_konusuyor: map['kimle_konusuyor'] ?? '',
      goruldu: map['goruldu'] ?? false,
      olusturulma_tarihi:
          (map['olusturulma_tarihi'] as Timestamp?) ?? Timestamp.now(),
      son_yollanan_mesaj: map['son_yollanan_mesaj'] ?? '',
      son_gorulme: (map['son_gorulme'] as Timestamp?) ?? Timestamp.now(),
      konusulanUserName: map['konusulanUserName'],
      konusulanUserProfilUrl: map['konusulanUserProfilUrl'],
    );
  }

  @override
  String toString() {
    return 'KonusmaModel(konusma_sahibi: $konusma_sahibi, kimle_konusuyor: $kimle_konusuyor, goruldu: $goruldu, olusturulma_tarihi: $olusturulma_tarihi, son_yollanan_mesaj: $son_yollanan_mesaj, son_gorulme: $son_gorulme, konusulanUserName: $konusulanUserName, konusulanUserProfilUrl: $konusulanUserProfilUrl)';
  }
}
