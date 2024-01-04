class Barang {
  final String uraianId;
  final String subHeader;

  Barang({required this.uraianId, required this.subHeader});

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      uraianId: json['uraian_id'],
      subHeader: json['sub_header'],
    );
  }
}
