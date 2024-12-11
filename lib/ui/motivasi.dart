import 'package:flutter/material.dart';
import 'package:vigenesia/helper/api_client.dart';
import 'package:vigenesia/ui/detail.dart';
import 'dart:async';
import '../model/motivasi.dart';
import '../../services/motivation_service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'artikel_form.dart';
import 'template.dart';

class MotivasiView extends StatefulWidget {
  const MotivasiView({Key? key}) : super(key: key);

  @override
  State<MotivasiView> createState() => _MotivasiViewState();
}

class _MotivasiViewState extends State<MotivasiView> {
  int currentPageIndex = 0;
  List<Motivasi>? data;

  Future<String> getData() async {
    var response = await MotivasiService().listData();

    this.setState(() {
      data = response;
    });

    if (data != null) {
      print(data![0].judul);
    }
    print('getData');
    return "Success!";
  }

  @override
  void initState() {
    this.getData();
    super.initState();
  }

  onDelete(id) async {
    var delete = await MotivasiService().delete(id);
    this.getData();
  }

  onEdit(id) {
    print(id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArtikelForm(type: 'edit', id: id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (data == null || data!.length == 0) {
      return ImageSection(
        image: 'assets/icon_motivation.png',
        width: 200,
        height: 200,
      );
    } else {
      return Scaffold(
        body: ListView.builder(
          itemCount: data == null ? 0 : data!.length,
          itemBuilder: (BuildContext context, int index) {
            final item = data![index];
            return Slidable(
              key: ValueKey(0),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (BuildContext context) {
                      onDelete(item.id); // Use a callback function
                    },
                    backgroundColor: const Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                  SlidableAction(
                    onPressed: (BuildContext context) {
                      onEdit(item.id); // Use a callback function
                    },
                    backgroundColor: const Color(0xFF21B7CA),
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Edit',
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                leading: Container(
                  width: 120.0, // Width of the square
                  height: 140.0, // Height of the square (same as width for a perfect square)
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(baseUrl + 'upload/motivasi/' + item.image),
                      fit: BoxFit.cover, // Ensures the image covers the square without distortion
                    ),
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners for the image
                    border: Border.all(
                      color: Colors.grey,  // Border color
                      width: 2.0,  // Border width
                    ),
                  ),
                ),
                title: Text(
                  item.judul,
                  maxLines: 2, // Max 2 lines of text
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  item.isi_motivasi,
                  maxLines: 2, // Max 2 lines of text
                  overflow: TextOverflow.ellipsis, // Show "..." when the text overflows
                  style: TextStyle(
                    fontSize: 14.0, // You can adjust the font size
                    color: Colors.black, // You can set the text color if needed
                  ),
                ),
                onTap: () {
                  // Navigate to the Motivasi detail page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailView(
                        type: 'Motivasi',
                        title: item.judul,
                        description: item.isi_motivasi,
                        imageSource: baseUrl + 'upload/motivasi/' + item.image,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),

      );
    }
  }
}
