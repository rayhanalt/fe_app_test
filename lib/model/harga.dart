class Harga {
  final String bm;
  final String cukai;

  Harga({required this.bm, required this.cukai});

  factory Harga.fromJson(Map<String, dynamic> json) {
    return Harga(
      bm: json['bm'],
      cukai: json['cukai'],
    );
  }
  String getBmValue() {
    return bm;
  }
}
