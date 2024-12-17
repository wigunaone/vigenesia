import 'package:flutter/material.dart';
import 'package:vigenesia/helper/api_client.dart';
import 'package:vigenesia/ui/detail.dart';
import 'dart:async';
import '../model/artikel.dart';
import '../../services/artikel_service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'artikel_form.dart';
import 'template.dart';
import '../helper/user_info.dart'; // Import UserInfo to access user data

class ArtikelView extends StatefulWidget {
  const ArtikelView({Key? key}) : super(key: key);

  @override
  State<ArtikelView> createState() => _ArtikelViewState();
}

class _ArtikelViewState extends State<ArtikelView> {
  int currentPageIndex = 0;
  List<Artikel>? data;
  String filterType = 'all';  // 'all' or 'user'
  UserInfo _userInfo = UserInfo(); // Create an instance of UserInfo
  TextEditingController searchController = TextEditingController(); // Controller for search field
  String searchQuery = ''; // The search query

  // Function to get articles based on the filter
  Future<void> getData() async {
    List<Artikel> response = [];

    if (filterType == 'user') {
      String userId = await _userInfo.getUserID(); // Get user ID from shared preferences
      print(userId + ' userid');
      if (userId.isNotEmpty) {
        // Pass search query to service method
        response = await ArtikelService().listDataByUserId(userId, searchQuery: searchQuery); 
      } else {
        // Handle case when user ID is not available
        print("User ID is not available");
        response = [];
      }
    } else {
      // Pass search query to service method for all articles
      response = await ArtikelService().listData(searchQuery: searchQuery); 
    }

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

  // Handle deleting an article
  onDelete(id) async {
    var delete = await ArtikelService().delete(id);
    getData(); // Refresh data after delete
  }

  // Navigate to edit screen for an article
  onEdit(id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArtikelForm(type: 'edit', id: id),
      ),
    );
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
                    hintText: 'Search by Judul',
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
          // PopupMenuButton for filter options
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: PopupMenuButton<String>(
        onSelected: (String value) {
          setState(() {
            filterType = value;
          });
          getData(); // Refresh data based on selected filter
        },
        itemBuilder: (BuildContext context) => [
          PopupMenuItem<String>(
            value: 'all',
            child: Text(
              'All Articles',
              style: TextStyle(
                color: filterType == 'all' ? Colors.grey[700] : Colors.black, // Darker color when 'all' is selected
              ),
            ),
          ),
          PopupMenuItem<String>(
            value: 'user',
            child: Text(
              'Articles by User',
              style: TextStyle(
                color: filterType == 'user' ? Colors.grey[700] : Colors.black, // Darker color when 'user' is selected
              ),
            ),
          ),
        ],
        child: Icon(Icons.filter_list),
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
              filterType == 'user' ? 'No articles found for this user.' : 'No articles available.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      )
    : ListView.builder(
        itemCount: data!.length,
        itemBuilder: (BuildContext context, int index) {
          final item = data![index];
          
          // Conditionally render the Slidable actions based on filterType
          return Slidable(
            key: ValueKey(item.id),
            endActionPane: filterType == 'all' // Check if filterType is 'all'
                ? null // If filterType is 'all', don't show any actions
                : ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (BuildContext context) {
                          onDelete(item.id); // Use a callback function for delete
                        },
                        backgroundColor: const Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                      SlidableAction(
                        onPressed: (BuildContext context) {
                          onEdit(item.id); // Use a callback function for edit
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
                width: 120.0,
                height: 120.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(baseUrl + 'upload/artikel/' + item.image),
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
                item.artikel,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14.0, color: Colors.black),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailView(
                      type: 'Artikel',
                      title: item.judul,
                      description: item.artikel,
                      imageSource: baseUrl + 'upload/artikel/' + item.image,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArtikelForm(type: 'add', id: ""),
            ),
          );
        },
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
    );
  }
}
