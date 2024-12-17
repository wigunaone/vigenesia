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
    print(data);
    setState(() {
      _judulCtrl.text = data.judul;
      _artikelCtrl.text = data.artikel;
      image = data.image;
    });
    return data;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      print(widget.type + ' type');
      print(widget.id + ' id');
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
        id: id,
        judul: _judulCtrl.text,
        artikel: _artikelCtrl.text,
        image: _imageCtrl.text == '' ? image : _imageCtrl.text , 
        idUser: userId,
        created: '', 
        updated: '', // Gambar yang di-upload
      );

      if (_type == 'edit') {
        await ArtikelService().update(artikel, id).then((value) {
          Navigator.pop(context);
        });
      } else {
        await ArtikelService().save(artikel).then((value) {
          Navigator.pop(context);
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
                    _fieldDescription(),  // Updated to TextArea
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
    return TextFormField(
      decoration: const InputDecoration(labelText: "Artikel"),
      controller: _artikelCtrl,
      maxLines: 5,  // Set the maximum number of lines
      keyboardType: TextInputType.multiline,  // Allow multiline input
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Deskripsi artikel tidak boleh kosong';
        }
        return null;  // Return null if the value is valid
      },
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

