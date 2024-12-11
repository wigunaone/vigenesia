import 'package:flutter/material.dart';
import 'package:vigenesia/ui/register.dart';
import './login.dart';
import 'template.dart';
class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[50],
        body: SingleChildScrollView(
            child: Column(
          children: [
            const ImageSection(image: 'assets/icon_motivation.png', width: 200, height: 200),
            const TextSection(
                title: "Vigenesia",
                description: "Inspirasi untuk Langkah Lebih Baik.",
                textalignment: "center"),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200, 40),

                  // padding: EdgeInsets.fromLTRB(55, 20, 55, 20),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ));
              },
              child: const Text('Login'),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200, 40),
                  // padding: EdgeInsets.fromLTRB(55, 20, 55, 20),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Register(),
                    ));
              },
              child: const Text('Register'),
            ),
          ],
        )));
  }
}

