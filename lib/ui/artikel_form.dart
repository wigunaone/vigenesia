// import 'package:flutter/material.dart';
// import '../services/artikel_service.dart';
// import '../ui/base.dart';
// import '../model/artikel.dart';

// class ArtikelForm extends StatefulWidget {
//   const ArtikelForm({Key? key, required this.type, this.id}) : super(key: key);
//   // ignore: prefer_typing_uninitialized_variables
//   final type;
//   // ignore: prefer_typing_uninitialized_variables
//   final id;
//   @override
//   State<ArtikelForm> createState() => _ArtikelFormState();
// }

// class _ArtikelFormState extends State<ArtikelForm> {
//   Artikel? artikel;
//   final _formKey = GlobalKey<FormState>();
//   String _type = '';
//   String id = '';
//   String image = '';
//   final _judulCtrl = TextEditingController();
//   final _artikelCtrl = TextEditingController();
//   final _imageCtrl = TextEditingController();

//   Future getData(id) async {
//     Artikel data = await ArtikelService().getById(id);
//     // ignore: unnecessary_this
//     this.setState(() {
//       _judulCtrl.text = data.judul;
//       _artikelCtrl.text = data.artikel;
//     });
//     return data;
//   }

//   @override
//   void initState() {
//     setState(() {
//       _type = widget.type;

//       id = widget.id;
//       if (widget.type == 'edit') {
//         getData(id);
//       }
//     });

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SingleChildScrollView(
//             child: Column(
//       children: [
//         Row(
//           children: [
//             FloatingActionButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               backgroundColor: const Color(0xFF64C1DF),
//               child: const Icon(
//                 Icons.arrow_back,
//                 size: 20,
//                 color: Colors.black,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
//               child: Text(
//                 _type.toUpperCase(),
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             )
//           ],
//         ),
//         Form(
//           key: _formKey,
//           child: Container(
//             padding: const EdgeInsets.only(left: 20, right: 20),
//             child: Column(
//               children: [
//                 _fieldTitle(),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 _fieldDescription(),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 _tombolSimpan()
//               ],
//             ),
//           ),
//         ),
//       ],
//     )));
//   }

//   _fieldTitle() {
//     return TextField(
//       decoration: const InputDecoration(labelText: "Judul"),
//       controller: _judulCtrl,
//     );
//   }

//   _fieldDescription() {
//     return TextField(
//       decoration: const InputDecoration(labelText: "Artikel"),
//       controller: _artikelCtrl,
//     );
//   }

//   _tombolSimpan() {
//     return ElevatedButton(
//         onPressed: () async {
//           // Artikel artikel =
//           //     Artikel(judul: _judulCtrl.text, artikel: _artikelCtrl.text, image: _imageCtrl.text);
//           // if (_type == 'edit') {
//           //   // ignore: unused_local_variable
//           //   var update = await ArtikelService()
//           //       .update(artikel, id)
//           //       .then((value) => Navigator.push(
//           //           // ignore: use_build_context_synchronously
//           //           context,
//           //           MaterialPageRoute(
//           //             builder: (context) => const Base(),
//           //           )));
//           // } else {
//           //   // ignore: unused_local_variable
//           //   var tambah =
//           //       await ArtikelService().save(artikel).then((value) => Navigator.push(
//           //           // ignore: use_build_context_synchronously
//           //           context,
//           //           MaterialPageRoute(
//           //             builder: (context) => const Base(),
//           //           )));
//           // }
//         },
//         child: const Text("Simpan"));
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vigenesia/helper/user_info.dart';
import 'package:vigenesia/ui/base.dart';
import '../services/artikel_service.dart';
import '../model/artikel.dart';
import '../helper/api_client.dart'; // Import ApiClient

class ArtikelForm extends StatefulWidget {
  const ArtikelForm({Key? key, required this.type, this.id}) : super(key: key);

  final type;
  final id;

  @override
  State<ArtikelForm> createState() => _ArtikelFormState();
}

class _ArtikelFormState extends State<ArtikelForm> {
  Artikel? artikel;
  final _formKey = GlobalKey<FormState>();
  String _type = '';
  String id = '';
  String image = ''; // Untuk menyimpan nama gambar yang diupload
  File? _imageFile;
  final _judulCtrl = TextEditingController();
  final _artikelCtrl = TextEditingController();
  final _imageCtrl = TextEditingController(); // Untuk field gambar

  final picker = ImagePicker();
  String userId = ""; 

  Future<void> _loadUserID() async {
    String user = await UserInfo().getUserID();
    setState(() {
      userId = user; // Update userId
    });
  }

  Future getData(id) async {
    Artikel data = await ArtikelService().getById(id);
    setState(() {
      _judulCtrl.text = data.judul;
      _artikelCtrl.text = data.artikel;
    });
    return data;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _type = widget.type;
      id = widget.id;
      _loadUserID();
      if (_type == 'edit') {
        getData(id);
      }
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        _imageCtrl.text = pickedFile.name; // Menampilkan nama file gambar di field
      }
    });
  }

  // Fungsi untuk meng-upload gambar ke server
  Future<void> _uploadImage() async {
    if (_imageFile == null) {
      print("No image selected");
      return;
    }

    try {
      String? imageName = await ArtikelService().uploadImage(_imageFile!);

      if (imageName != null) {
        print("Upload berhasil, image name: $imageName");
        setState(() {
          _imageCtrl.text = imageName; // Isi text field dengan 'name' gambar
        });
      } else {
        print("Upload gambar gagal");
      }
    } catch (e) {
      print("Terjadi kesalahan saat upload: $e");
    }
  }

  _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      Artikel artikel = Artikel(
        judul: _judulCtrl.text,
        artikel: _artikelCtrl.text,
        image: _imageCtrl.text, 
        idUser: userId,
        created: '', 
        updated: '', // Gambar yang di-upload
      );

      if (_type == 'edit') {
        await ArtikelService().update(artikel, id).then((value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Base()),
          );
        });
      } else {
        await ArtikelService().save(artikel).then((value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Base()),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 20.0), // Add top and left margin
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder( // Use a custom shape
                      borderRadius: BorderRadius.circular(50), // Circular button with radius 50
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Text(
                    _type.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _fieldTitle(),
                    const SizedBox(height: 20),
                    _fieldDescription(),
                    const SizedBox(height: 20),
                    _fieldImage(),
                    const SizedBox(height: 20),
                    _tombolSimpan(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _fieldTitle() {
    return TextField(
      decoration: const InputDecoration(labelText: "Judul"),
      controller: _judulCtrl,
    );
  }

  _fieldDescription() {
    return TextField(
      decoration: const InputDecoration(labelText: "Artikel"),
      controller: _artikelCtrl,
    );
  }

  _fieldImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: _pickImage,
          child: const Text("Pilih Gambar"),
        ),
        TextField(
          controller: _imageCtrl,
          decoration: const InputDecoration(labelText: "Nama Gambar"),
          readOnly: true,
        ),
      ],
    );
  }

  _tombolSimpan() {
    return ElevatedButton(
      onPressed: () async {
        await _uploadImage(); // Upload gambar sebelum simpan artikel
        await _submitForm();
      },
      child: const Text("Simpan"),
    );
  }
}
