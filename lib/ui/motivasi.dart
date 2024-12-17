import 'package:flutter/material.dart';
import 'package:vigenesia/helper/api_client.dart';
import 'package:vigenesia/ui/detail.dart';
import 'dart:async';
import '../model/motivasi.dart';
import '../../services/motivation_service.dart';
import 'artikel_form.dart';
import 'template.dart';
import '../helper/user_info.dart'; // Import UserInfo to access user data

class MotivasiView extends StatefulWidget {
  const MotivasiView({Key? key}) : super(key: key);

  @override
  State<MotivasiView> createState() => _MotivasiViewState();
}

class _MotivasiViewState extends State<MotivasiView> {
  List<Motivasi>? data;
  TextEditingController searchController = TextEditingController(); // Controller for search field
  String searchQuery = ''; // The search query

  // Function to get motivasi based on the search query
  Future<void> getData() async {
    List<Motivasi> response = await MotivasiService().listData(searchQuery: searchQuery);

    setState(() {
      data = response;
    });

    if (data != null) {
      print(data![0].judul); // Optional: Check the data being loaded
    }
    print('getData');
  }

  @override
  void initState() {
    super.initState();
    getData(); // Fetch data when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // Remove the back button
        title: null, // Remove the default title (optional, if you want to fully customize it)
        actions: [
          // Search Input Field
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0), // Align left with a small margin
              child: Container(
                width: double.infinity, // Make it expand to the full available width
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search Motivasi...',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          searchQuery = searchController.text.trim();
                        });
                        getData(); // Refresh data based on search query
                      },
                    ),
                  ),
                  onSubmitted: (_) {
                    setState(() {
                      searchQuery = searchController.text.trim();
                    });
                    getData(); // Refresh data based on search query
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: data == null || data!.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icon_motivation.png',
                    width: 200,
                    height: 200,
                  ),
                  Text(
                    'No motivasi available.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: data!.length,
              itemBuilder: (BuildContext context, int index) {
                final item = data![index];

                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  leading: Container(
                    width: 120.0,
                    height: 120.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(baseUrl + 'upload/motivasi/' + item.image),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey, width: 2.0),
                    ),
                  ),
                  title: Text(
                    item.judul,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    item.isi_motivasi,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                  onTap: () {
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
                );
              },
            ),
    );
  }
}
