import 'package:appnoppv/model.dart';
import 'package:appnoppv/readpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChapterListPage extends StatefulWidget {
  final Story story;
  const ChapterListPage({
    Key? key,
    required this.story,
  }) : super(key: key);

  @override
  _ChapterListPageState createState() => _ChapterListPageState();
}

class _ChapterListPageState extends State<ChapterListPage> {
  final String baseUrl = 'https://truyen-clone.getdata.one';

  List<Chapter> chapters = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = '${baseUrl}/story/${widget.story.slug}/chapters';
    print(url);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      chapters = data.map((e) => Chapter.fromJson(e)).toList();
      setState(() {});
    }
  }

  void handleChapterSelection(Chapter chapter) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReaderPage(chapter: chapter),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(widget.story.slug.toString()),
    ),
    body: chapters.isEmpty
      ? Center(child: CircularProgressIndicator())
      : ListView.builder(
        itemCount: chapters.length,
        itemBuilder: (_, index) {
          final chapter = chapters[index];
          return Card(
            child: InkWell(
              onTap: () => handleChapterSelection(chapter),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chapter.header.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Viewed ${chapter.viewCount} times',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                     
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
  );
}
}
