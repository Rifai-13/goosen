class MenuMakanan {
  final int id;
  final String nama;
  final int harga;
  final String deskripsi;
  final String gambar;
  final double rating;
  final String distance;
  final String duration;
  final String terjual;

  MenuMakanan({
    required this.id,
    required this.nama,
    required this.harga,
    required this.deskripsi,
    required this.gambar,
    required this.rating,
    required this.distance,
    required this.duration,
    required this.terjual,
  });

  factory MenuMakanan.fromJson(Map<String, dynamic> json) {
    return MenuMakanan(
      id: json['id'] ?? 0,
      nama: json['nama'] ?? '',
      harga: json['harga'] ?? 0,
      deskripsi: json['deskripsi'] ?? '',
      gambar: json['gambar'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      distance: json['distance'] ?? '0 km',
      duration: json['duration'] ?? '0 min',
      terjual: json['terjual'] ?? '0',
    );
  }
}