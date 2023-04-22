import 'package:appnoppv/model.dart';
import 'package:appnoppv/storylistpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String baseUrl = 'https://truyen-clone.getdata.one';
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = '$baseUrl/category/id/1/story';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      categories = data.map((e) => Category.fromJson(e)).toList();
      setState(() {});
    }
  }

  void handleCategorySelection(Category category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StoryListPage(category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Truyen Clone App'),
        actions: [
          PopupMenuButton<Category>(
            onSelected: handleCategorySelection,
            itemBuilder: (BuildContext context) {
              return categories.map((Category category) {
                return PopupMenuItem<Category>(
                  value: category,
                  child: Text(category.title),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: categories.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: categories.length,
              itemBuilder: (_, index) {
                final category = categories[index];
                return Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // category.poster != null
                      //     ? ClipRRect(
                      //         borderRadius: BorderRadius.circular(8),
                      //         child: Image.network(
                      //           category.poster,
                      //           fit: BoxFit.cover,
                      //           height: 30,
                      //           width: 30,
                      //         ),
                      //       )
                      //     : Icon(Icons.category, size: 50),
                      // SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Author: ${category.author}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        onPressed: () => handleCategorySelection(category),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
