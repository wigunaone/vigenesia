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
        ? const CircularProgressIndicator()
        : CarouselSlider(
            options: CarouselOptions(
              height: 250.0,
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
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        // Gambar motivasi
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            baseUrl + 'upload/motivasi/' +  motivasi.image, // Ganti dengan URL API gambar
                            height: 150.0,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Judul dan isi motivasi
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            motivasi.judul,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            motivasi.isi_motivasi,
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }).toList(),
          );
  }

  // Menampilkan Artikel dalam ListView
  Widget _artikelListView() {
    if (dataArtikel == null || dataArtikel!.isEmpty) {
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
          return Slidable(
            key: ValueKey(item.id),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (BuildContext context) {
                    onDelete(item.id);
                  },
                  backgroundColor: const Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
                SlidableAction(
                  onPressed: (BuildContext context) {
                    onEdit(item.id);
                  },
                  backgroundColor: const Color(0xFF21B7CA),
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'Edit',
                ),
              ],
            ),
             child: GestureDetector(
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
                title: Text(item.judul),
                subtitle: Text(
                  item.artikel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
