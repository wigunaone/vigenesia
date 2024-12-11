import 'package:flutter/material.dart';
import 'base.dart';
import '../services/auth_service.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                      _emailTextField(),
                      const SizedBox(
                        height: 20,
                      ),
                      _passwordTextField(),
                      const SizedBox(
                        height: 30,
                      ),
                      _tombolLogin()
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

  _passwordTextField() {
    return TextFormField(
      decoration: const InputDecoration(label: Text("Password")),
      obscureText: true,
      controller: _passwordCtrl,
    );
  }

  _tombolLogin() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 40),

                // padding: EdgeInsets.fromLTRB(55, 20, 55, 20),
                foregroundColor: Colors.white,
                backgroundColor: Colors.black),
            child: const Text("Login"),
            onPressed: () async {
              String email = _emailCtrl.text;
              String password = _passwordCtrl.text;
              await AuthService().login(email, password).then((value) {
                print(value);
                print('value');
                if (value == true) {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => const Base()));
                } else {
                  AlertDialog alertDialog = AlertDialog(
                    content: const Text("Email atau Password Tidak Valid"),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(),
                        child: const Text("OK"),
                      )
                    ],
                  );
                  showDialog(
                      // ignore: use_build_context_synchronously
                      context: context, builder: (context) => alertDialog);
                }
              });
            }));
  }
}
