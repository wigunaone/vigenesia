import 'package:flutter/material.dart';

class DetailView extends StatelessWidget {
  final String type;
  final String title;
  final String description;
  final String imageSource;

  const DetailView({
    Key? key,
    required this.type,
    required this.title,
    required this.description,
    required this.imageSource,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(type), // Nama aplikasi
        foregroundColor: Colors.white,
        backgroundColor: Colors.black, // Sesuaikan warna jika perlu
        elevation: 0, // Menghilangkan bayangan appbar
      ),
      body: SingleChildScrollView( // Membuat seluruh body menjadi scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
               // Image
              Container(
                width: double.infinity,
                height: 250.0, // Sesuaikan dengan tinggi gambar
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageSource),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Colors.grey,  // Border color
                    width: 2.0,  // Border width
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              
              // Title
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'RadioCanada',
                  fontSize: 24.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.0),

             
              Text(
                description,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,

                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
