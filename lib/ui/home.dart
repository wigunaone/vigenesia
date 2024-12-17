// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:vigenesia/helper/api_client.dart';
// import 'package:vigenesia/services/artikel_service.dart';
// import 'package:vigenesia/model/artikel.dart';
// import 'package:vigenesia/model/motivasi.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:vigenesia/services/motivation_service.dart';
// import 'package:vigenesia/ui/detail.dart';
// import 'artikel_form.dart';

// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   List<Artikel>? dataArtikel;
//   List<Motivasi> dataMotivasi = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadArtikelData();
//     _loadMotivasiData();
//   }

//   // Mengambil data artikel
//   Future<void> _loadArtikelData() async {
//     List<Artikel> artikel = await ArtikelService().listData();
//     setState(() {
//       dataArtikel = artikel;
//     });
//   }

//   // Mengambil data motivasi
//   Future<void> _loadMotivasiData() async {
//     List<Motivasi> motivasi = await MotivasiService().listData();
//     setState(() {
//       dataMotivasi = motivasi;
//     });
//   }

//   // Fungsi untuk menghapus artikel
//   onDelete(id) async {
//     var delete = await ArtikelService().delete(id);
//     _loadArtikelData();
//   }

//   // Fungsi untuk mengedit artikel
//   onEdit(id) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ArtikelForm(type: 'edit', id: id),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
      
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//            _motivasiCarousel(),
//       const SizedBox(height: 20),
      
//       // Rekomendasi Artikel dengan styling
//       const Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.0),
//         child: Text(
//           'Rekomendasi Artikel',
//           style: TextStyle(
//             fontSize: 18,  // Ukuran font
//             fontWeight: FontWeight.bold,  // Membuat teks bold
//           ),
//           textAlign: TextAlign.left,  // Rata kiri
//         ),
//       ),

//       // Artikel ListView
//       _artikelListView(),
//           ],
//         ),
//       ),
//     );
//   }

//   // Menampilkan Motivasi dalam Horizontal Carousel
//   // Widget _motivasiCarousel() {
//   // return dataMotivasi.isEmpty
//   //     ? const CircularProgressIndicator()
//   //     : CarouselSlider(
//   //         options: CarouselOptions(
//   //           height: 280.0,
//   //           enlargeCenterPage: true,
//   //           autoPlay: true,
//   //           aspectRatio: 16 / 9,
//   //           autoPlayInterval: const Duration(seconds: 5),
//   //           autoPlayAnimationDuration: const Duration(milliseconds: 800),
//   //           viewportFraction: 0.8,
//   //         ),
//   //         items: dataMotivasi.map((motivasi) {
//   //           return Builder(
//   //             builder: (BuildContext context) {
//   //               return Card(
//   //                 shape: RoundedRectangleBorder(
//   //                   borderRadius: BorderRadius.circular(12),
//   //                 ),
//   //                 elevation: 4,
//   //                 margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//   //                 color: Colors.white,  // Set the background color to white
//   //                 child: Column(
//   //                   children: [
//   //                     // Gambar motivasi
//   //                     ClipRRect(
//   //                       borderRadius: BorderRadius.circular(12),
//   //                       child: Image.network(
//   //                         baseUrl + 'upload/motivasi/' + motivasi.image, // Ganti dengan URL API gambar
//   //                         height: 150.0,
//   //                         width: double.infinity,
//   //                         fit: BoxFit.cover,
//   //                       ),
//   //                     ),
//   //                     const SizedBox(height: 16),
//   //                     // Judul dan isi motivasi
//   //                     Padding(
//   //                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//   //                       child: Text(
//   //                         motivasi.judul,
//   //                         style: const TextStyle(
//   //                           fontFamily: 'RadioCanada',
//   //                           fontSize: 18,
//   //                           fontWeight: FontWeight.w700,
//   //                         ),
//   //                         textAlign: TextAlign.center,
//   //                       ),
//   //                     ),
//   //                     const SizedBox(height: 2),
//   //                     Padding(
//   //                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//   //                       child: Text(
//   //                         motivasi.isi_motivasi,
//   //                         style: const TextStyle(
//   //                           fontFamily: 'RadioCanada',
//   //                           fontSize: 14,
//   //                           fontWeight: FontWeight.w900,
//   //                         ),
//   //                         textAlign: TextAlign.center,
//   //                         maxLines: 1,
//   //                         overflow: TextOverflow.ellipsis,
//   //                       ),
//   //                     ),
//   //                   ],
//   //                 ),
//   //               );
//   //             },
//   //           );
//   //         }).toList(),
//   //       );
// // }
// Widget _motivasiCarousel() {
//   return dataMotivasi.isEmpty
//       ? const CircularProgressIndicator()
//       : CarouselSlider(
//           options: CarouselOptions(
//             height: 200.0,
//             enlargeCenterPage: true,
//             autoPlay: true,
//             aspectRatio: 16 / 9,
//             autoPlayInterval: const Duration(seconds: 5),
//             autoPlayAnimationDuration: const Duration(milliseconds: 800),
//             viewportFraction: 0.8,
//           ),
//           items: dataMotivasi.map((motivasi) {
//             return Builder(
//               builder: (BuildContext context) {
//                 return Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 4,
//                   margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                   color: Colors.white,  // Set the background color to white
//                   child: Stack(
//                     children: [
//                       // Gambar motivasi sebagai background
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.network(
//                           baseUrl + 'upload/motivasi/' + motivasi.image,
//                           height: 150.0,
//                           width: double.infinity,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       // Overlay untuk judul dan isi motivasi
//                       Positioned(
//                         top: 0, // Atur posisi overlay dari atas
//                         left: 0,
//                         right: 0,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                           decoration: BoxDecoration(
//                             color: Colors.black.withOpacity(0.5), // Transparansi di background
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Column(
//                             children: [
//                               // Judul motivasi
//                               SizedBox(height: 130,),
//                               Text(
//                                 motivasi.judul,
//                                 style: const TextStyle(
//                                   fontFamily: 'RadioCanada',
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w700,
//                                   color: Colors.white, // Teks warna putih
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                               const SizedBox(height: 4),
//                               // Isi motivasi
//                               Text(
//                                 motivasi.isi_motivasi,
//                                 style: const TextStyle(
//                                   fontFamily: 'RadioCanada',
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w900,
//                                   color: Colors.white, // Teks warna putih
//                                 ),
//                                 textAlign: TextAlign.center,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           }).toList(),
//         );
// }

//   // Menampilkan Artikel dalam ListView
//  Widget _artikelListView() {
//   if (dataArtikel == null || dataArtikel!.isEmpty) {
//     return const Padding(
//       padding: EdgeInsets.all(16.0),
//       child: Text('Tidak ada artikel tersedia'),
//     );
//   } else {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(), // Untuk mencegah scroll ganda
//       itemCount: dataArtikel?.length,
//       itemBuilder: (BuildContext context, int index) {
//         final item = dataArtikel![index];
        
//         return GestureDetector(
//           onTap: () {
//             // Navigate to the Artikel detail page
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => DetailView(
//                   type: 'Artikel',
//                   title: item.judul,
//                   description: item.artikel,
//                   imageSource: baseUrl + 'upload/artikel/' + item.image,
//                 ),
//               ),
//             );
//           },
//           child: ListTile(
//             contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//             leading: Container(
//               width: 100.0,
//               height: 100.0,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: NetworkImage(baseUrl + 'upload/artikel/'  + item.image),
//                   fit: BoxFit.cover,
//                 ),
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//             ),
//             title: Text(
//               item.judul,
//               style : const TextStyle(
//                 fontFamily: 'Inter',
//                 fontWeight: FontWeight.w700,
//                 fontSize: 15.0,
//                 color: Colors.black
//               )
//               ),
//             subtitle: Text(
//               item.artikel,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(
//                 fontFamily: 'Inter',
//                 fontWeight: FontWeight.w300,
//                 fontSize: 14.0,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// }
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:vigenesia/helper/api_client.dart';
import 'package:vigenesia/services/artikel_service.dart';
import 'package:vigenesia/model/artikel.dart';
import 'package:vigenesia/model/motivasi.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:vigenesia/services/motivation_service.dart';
import 'package:vigenesia/ui/detail.dart';
import 'artikel_form.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Artikel>? dataArtikel;
  List<Motivasi> dataMotivasi = [];

  @override
  void initState() {
    super.initState();
    _loadArtikelData();
    _loadMotivasiData();
  }

  // Mengambil data artikel
  Future<void> _loadArtikelData() async {
    List<Artikel> artikel = await ArtikelService().listData();
    setState(() {
      dataArtikel = artikel;
    });
  }

  // Mengambil data motivasi
  Future<void> _loadMotivasiData() async {
    List<Motivasi> motivasi = await MotivasiService().listData();
    setState(() {
      dataMotivasi = motivasi;
    });
  }

  // Fungsi untuk menghapus artikel
  onDelete(id) async {
    var delete = await ArtikelService().delete(id);
    _loadArtikelData();
  }

  // Fungsi untuk mengedit artikel
  onEdit(id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArtikelForm(type: 'edit', id: id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _motivasiCarousel(),
            const SizedBox(height: 20),

            // Rekomendasi Artikel dengan styling
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Rekomendasi Artikel',
                style: TextStyle(
                  fontSize: 18,  // Ukuran font
                  fontWeight: FontWeight.bold,  // Membuat teks bold
                ),
                textAlign: TextAlign.left,  // Rata kiri
              ),
            ),

            // Artikel ListView
            _artikelListView(),
          ],
        ),
      ),
    );
  }

  // Menampilkan Motivasi dalam Horizontal Carousel
  Widget _motivasiCarousel() {
  return dataMotivasi.isEmpty
      ? const Center(child: CircularProgressIndicator()) // Placeholder saat data motivasi kosong
      : CarouselSlider(
          options: CarouselOptions(
            height: 200.0,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            viewportFraction: 0.8,
          ),
          items: dataMotivasi.map((motivasi) {
            return Builder(
              builder: (BuildContext context) {
                return InkWell(
                  onTap: () {
                    // Navigate to the Motivasi detail page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailView(
                          type: 'Motivasi',
                          title: motivasi.judul,
                          description: motivasi.isi_motivasi,
                          imageSource: baseUrl + 'upload/motivasi/' + motivasi.image,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    color: Colors.white,  // Set the background color to white
                    child: Stack(
                      children: [
                        // Gambar motivasi sebagai background dengan loading placeholder
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            baseUrl + 'upload/motivasi/' + motivasi.image,
                            height: 150.0,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;  // Jika gambar sudah dimuat, tampilkan gambar
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            (loadingProgress.expectedTotalBytes ?? 1)
                                        : null,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        // Overlay untuk judul dan isi motivasi
                        Positioned(
                          top: 0, // Atur posisi overlay dari atas
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5), // Transparansi di background
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                // Judul motivasi
                                SizedBox(height: 130),
                                Text(
                                  motivasi.judul,
                                  style: const TextStyle(
                                    fontFamily: 'RadioCanada',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white, // Teks warna putih
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                // Isi motivasi
                                Text(
                                  motivasi.isi_motivasi,
                                  style: const TextStyle(
                                    fontFamily: 'RadioCanada',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white, // Teks warna putih
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        );
}

  // Menampilkan Artikel dalam ListView
  Widget _artikelListView() {
    if (dataArtikel == null) {
      return const Center(
        child: CircularProgressIndicator(),  // Placeholder saat data artikel sedang dimuat
      );
    } else if (dataArtikel!.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Tidak ada artikel tersedia'),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(), // Untuk mencegah scroll ganda
        itemCount: dataArtikel?.length,
        itemBuilder: (BuildContext context, int index) {
          final item = dataArtikel![index];

          return GestureDetector(
            onTap: () {
              // Navigate to the Artikel detail page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailView(
                    type: 'Artikel',
                    title: item.judul,
                    description: item.artikel,
                    imageSource: baseUrl + 'upload/artikel/' + item.image,
                  ),
                ),
              );
            },
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              leading: Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(baseUrl + 'upload/artikel/'  + item.image),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              title: Text(
                item.judul,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 15.0,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                item.artikel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w300,
                  fontSize: 14.0,
                  color: Colors.black,
                ),
              ),
            ),
          );
        },
      );
    }
  }
}

