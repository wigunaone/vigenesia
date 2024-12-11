import 'package:flutter/material.dart';
import 'package:vigenesia/ui/welcome.dart';
import '../helper/user_info.dart';
import 'template.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String email = "Loading..."; // Set default value

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  // Fungsi untuk mengambil email dari SharedPreferences
  Future<void> _loadEmail() async {
    String user = await UserInfo().getEmail();
    setState(() {
      email = user; // Update email
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const ImageSection(image: 'assets/icon_article.png', width: 200, height: 200),
          // Menampilkan email yang diambil dari SharedPreferences
          Center(child: Text(email, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
          ElevatedButton(
            onPressed: () async {
              await UserInfo().logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Welcome(),
                ),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
