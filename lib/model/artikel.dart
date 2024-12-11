class Artikel {
  final String? id;  // Changed from 'idArtikel' to 'id'
  final String judul;
  final String artikel;
  final String idUser;
  final String created;
  final String updated;
  final String image;

  Artikel({
    this.id,  // Changed from 'idArtikel' to 'id'
    required this.judul,
    required this.artikel,
    required this.idUser,
    required this.created,
    required this.updated,
    required this.image,
  });

  factory Artikel.fromJson(Map<String, dynamic> json) {
    return Artikel(
      id: json['id_artikel'] ?? '', // Default empty string if null
      judul: json['judul'] ?? '', // Default empty string if null
      artikel: json['artikel'] ?? '', // Default empty string if null
      idUser: json['id_user'] ?? '', // Default empty string if null
      created: json['created'] ?? '', // Default empty string if null
      updated: json['updated'] ?? '', // Default empty string if null
      image: json['image'] ?? '', // Default empty string if null
    );
  }

  // Method to convert an Artikel object to a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id_artikel': id,  // Updated field name to match the original API key
      'judul': judul,
      'artikel': artikel,
      'id_user': idUser,
      'created': created,
      'updated': updated,
      'image': image,
    };
  }
}
