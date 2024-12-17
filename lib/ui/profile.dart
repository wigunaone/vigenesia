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
    _loadInfo();
  }

  // Fungsi untuk mengambil email dari SharedPreferences
  Future<void> _loadInfo() async {
    String user = await UserInfo().getEmail();
    setState(() {
      email = user; // Update email
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background color
      body: Center(  // Center the whole content horizontally and vertically
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Padding around the content
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,  // Center the content vertically
              crossAxisAlignment: CrossAxisAlignment.center,  // Center the content horizontally
              children: [
                // Profile image section
                CircleAvatar(
                  radius: 80.0,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: AssetImage('assets/icon_article.png'), // You can replace this with actual user photo
                ),
                const SizedBox(height: 20.0),

                // Email section
                Text(
                  'Email :  ' + email,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10.0),

                // Add some descriptive text
                Text(
                  'Welcome to your profile!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30.0),

                // Logout Button
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
                  style: ElevatedButton.styleFrom(// Button color
                    backgroundColor: Colors.red[400],
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // Rounded button corners
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
