class Pelabuhan {
  final String kdPelabuhan;
  final String urPelabuhan;

  Pelabuhan({required this.kdPelabuhan, required this.urPelabuhan});

  factory Pelabuhan.fromJson(Map<String, dynamic> json) {
    return Pelabuhan(
      kdPelabuhan: json['kd_pelabuhan'],
      urPelabuhan: json['ur_pelabuhan'],
    );
  }

  bool matchesQuery(String query) {
    return kdPelabuhan.toLowerCase().startsWith(query.toLowerCase()) ||
        urPelabuhan.toLowerCase().startsWith(query.toLowerCase());
  }

  @override
  String toString() {
    return urPelabuhan;
  }
}
