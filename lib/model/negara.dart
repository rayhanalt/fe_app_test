class Negara {
  final String kdNegara;
  final String urNegara;

  Negara({required this.kdNegara, required this.urNegara});

  factory Negara.fromJson(Map<String, dynamic> json) {
    return Negara(
      kdNegara: json['kd_negara'],
      urNegara: json['ur_negara'],
    );
  }

  bool matchesQuery(String query) {
    return kdNegara.toLowerCase().startsWith(query.toLowerCase()) ||
        urNegara.toLowerCase().startsWith(query.toLowerCase());
  }

  @override
  String toString() {
    return urNegara;
  }
}
