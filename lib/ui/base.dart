import 'package:flutter/material.dart';
import 'package:vigenesia/ui/artikel.dart';
import 'package:vigenesia/ui/motivasi.dart';
import '../ui/artikel_form.dart';
import '../ui/home.dart';
import '../ui/profile.dart';

class Base extends StatefulWidget {
  const Base({Key? key}) : super(key: key);

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vigenesia'), // Nama aplikasi
        foregroundColor: Colors.white,
        backgroundColor: Colors.black, // Sesuaikan warna jika perlu
        elevation: 0, // Menghilangkan bayangan appbar
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.grey,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.white,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          const NavigationDestination(
            // selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            
          ),
          const NavigationDestination(
            icon: Icon(Icons.article),
            label: 'Artikel',
          ),
         NavigationDestination(
            icon: Image.asset(
              'assets/icon_motivation.png',  // Gambar ikonnya
              width: 24,  // Sesuaikan ukuran gambar
              height: 24, // Sesuaikan ukuran gambar
            ),
            label: 'Motivasi',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
      body: <Widget>[
        Home(),
        ArtikelView(),
        MotivasiView(),
        Profile(),
      ][currentPageIndex], 
    );
  }
}