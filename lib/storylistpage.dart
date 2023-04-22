import 'package:appnoppv/chapterlistpage.dart';
import 'package:appnoppv/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StoryListPage extends StatefulWidget {
  final Category category;

  const StoryListPage({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  _StoryListPageState createState() => _StoryListPageState();
}

class _StoryListPageState extends State<StoryListPage> {
  final String baseUrl = 'https://truyen-clone.getdata.one';

  List<Story> stories = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = '${baseUrl}/category/id/${widget.category.id}/story';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      stories = data.map((e) => Story.fromJson(e)).toList();
      setState(() {});
    }
  }

  void handleStorySelection(Story story) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChapterListPage(story: story),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.title),
      ),
      body: stories.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: stories.length,
              itemBuilder: (_, index) {
                final story = stories[index];
                return GestureDetector(
                  onTap: () => handleStorySelection(story),
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => handleStorySelection(story),
                            child: Icon(
                              Icons.favorite_border,
                              color: Colors.grey,
                              size: 24.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            story.slug.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
