// ignore_for_file: non_constant_identifier_names

class Motivasi {
  String? id;
  String judul;
  String isi_motivasi;
  String image;

//   DateTime date;

  Motivasi({
    this.id,
    required this.judul,
    required this.isi_motivasi,
    //   required this.date
    required this.image
  });

  factory Motivasi.fromJson(Map<String, dynamic> json) => Motivasi(
        id: json["id"],
        judul: json["judul"],
        isi_motivasi: json["isi_motivasi"],
        image: json["image"]
        //   date: json["date"]
      );

  Map<String, dynamic> toJson() => {
        "judul": judul, 
        "isi_motivasi": isi_motivasi,
        "image": image,
        //   "date": date
      };
}
