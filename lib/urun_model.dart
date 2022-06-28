import 'dart:convert';

List<UrunModel> urunModelFromJson(String str) =>
    List<UrunModel>.from(json.decode(str).map((x) => UrunModel.fromJson(x)));

String urunModelToJson(List<UrunModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UrunModel {
  UrunModel({
    required this.id,
    required this.urunler,
  });

  String id;
  List<Urunler> urunler;

  factory UrunModel.fromJson(Map<String, dynamic> json) => UrunModel(
        id: json["_id"],
        urunler:
            List<Urunler>.from(json["urunler"].map((x) => Urunler.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "urunler": List<dynamic>.from(urunler.map((x) => x.toJson())),
      };
}

class Urunler {
  Urunler({
    required this.id,
    required this.marka,
    required this.urunAd,
    required this.barkod,
    required this.stok,
  });

  String id;
  String marka;
  String urunAd;
  String barkod;
  int stok;

  factory Urunler.fromJson(Map<String, dynamic> json) => Urunler(
        id: json["_id"],
        marka: json["marka"],
        urunAd: json["urunAd"],
        barkod: json["barkod"],
        stok: json["stok"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "marka": marka,
        "urunAd": urunAd,
        "barkod": barkod,
        "stok": stok,
      };
}
