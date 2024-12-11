import 'package:flutter/material.dart';
import 'base.dart';
import '../services/auth_service.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _namaCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: SafeArea(
          child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
      width: 200,
      height: 200,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.fromLTRB(0, 50, 0, 50),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      child: Image.asset(
        'assets/icon_motivation.png',
        fit: BoxFit.cover,
      ),
    )
            ),
            const Text(
              "Vigenesia",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Inspirasi untuk Langkah Lebih Baik.",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 50,
            ),
            Center(
              child: Form(
                key: _formKey,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: Column(
                    children: [
                      _namaTextField(),
                      const SizedBox(
                        height: 20,
                      ),
                      _emailTextField(),
                      const SizedBox(
                        height: 20,
                      ),
                      
                      _passwordTextField(),
                      const SizedBox(
                        height: 30,
                      ),
                      _tombolRegister()
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    ));
  }

  _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(label: Text("Email")),
      controller: _emailCtrl,
    );
  }
  _namaTextField() {
    return TextFormField(
      decoration: const InputDecoration(label: Text("Nama")),
      controller: _namaCtrl,
    );
  }

  _passwordTextField() {
    return TextFormField(
      decoration: const InputDecoration(label: Text("Password")),
      obscureText: true,
      controller: _passwordCtrl,
    );
  }

  _tombolRegister() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 40),

                // padding: EdgeInsets.fromLTRB(55, 20, 55, 20),
                foregroundColor: Colors.white,
                backgroundColor: Colors.black),
            child: const Text("Register"),
            onPressed: () async {
              String nama = _namaCtrl.text;
              String email = _emailCtrl.text;
              String password = _passwordCtrl.text;
              await AuthService().register(nama,email, password).then((value) {
                if (value == true) {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => const Base()));
                } else {
                  AlertDialog alertDialog = AlertDialog(
                    content: const Text("email atau Password Tidak Valid"),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("OK"),
                        style: ElevatedButton.styleFrom(),
                      )
                    ],
                  );
                  showDialog(
                      context: context, builder: (context) => alertDialog);
                }
              });
            }));
  }
}
