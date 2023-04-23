import 'package:appnoppv/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'dart:convert';

class ReaderPage extends StatefulWidget {
  final Chapter chapter;

  const ReaderPage({
    Key? key,
    required this.chapter,
  }) : super(key: key);

  @override
  _ReaderPageState createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  final String baseUrl = 'https://truyen-clone.getdata.one';

  String content = '';
  bool isLoading = false;
  // Add these variables for customizing the text style and background color
  double fontSize = 16;
  String fontFamily = 'Roboto';
  Color backgroundColor = Colors.white;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() => isLoading = true);
    final url = '${baseUrl}/chapter/id/${widget.chapter.id}';
    print(url);
    final response = await http.get(Uri.parse(url));
    String parseHtmlString(String htmlString) {
      var document = parse(htmlString);

      String parsedString = parse(document.body?.text).documentElement!.text;

      return parsedString;
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      content = parseHtmlString(data['body'].join(''));
      setState(() => isLoading = false);
    }
  }

  // String _parseHtmlString(String htmlString) {
  //   RegExp exp = RegExp(r"<[^]*?>", multiLine: true, caseSensitive: true);
  //   String parsedString = htmlString
  //       .replaceAll(exp, "") // Strip Tags
  //       .replaceAll("\n\n", "<p>") // Paragraphs
  //       .replaceAll("\n", "<br>") // Line Breaks
  //       .replaceAll('"', "&quot;") // Quote Marks
  //       .replaceAll("'", "&apos;") // Apostrophe
  //       .replaceAll(">", "&lt;") // Less-than Comparator
  //       .replaceAll("<", "&gt;")
  //       .trim(); // Whitespace

  //   return parsedString;
  // }

  void changeFontSize(double size) {
    setState(() {
      fontSize = size;
    });
  }

  void changeFontFamily(String? family) {
    setState(() {
      fontFamily = family ?? 'Roboto';
    });
  }

  void changeBackgroundColor(Color color) {
    setState(() {
      backgroundColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chapter.slug.toString()),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Font size'),
                textStyle: TextStyle(
                    fontSize: 16, fontFamily: 'Roboto', color: Colors.black),
                value: 1,
              ),
              PopupMenuItem(
                child: Text('Font family'),
                textStyle: TextStyle(
                    fontSize: 16, fontFamily: 'Roboto', color: Colors.black),
                value: 2,
              ),
              PopupMenuItem(
                child: Text('Background color'),
                textStyle: TextStyle(
                    fontSize: 16, fontFamily: 'Roboto', color: Colors.black),
                value: 3,
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 1:
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Font size'),
                      content: Slider(
                        value: fontSize,
                        min: 10,
                        max: 30,
                        onChanged: changeFontSize,
                      ),
                    ),
                  );
                  break;
                case 2:
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Font family'),
                      content: DropdownButton<String>(
                        value: fontFamily,
                        items: [
                          DropdownMenuItem(
                              child: Text('Roboto'), value: 'Roboto'),
                          DropdownMenuItem(
                              child: Text('Open Sans'), value: 'Open Sans'),
                          DropdownMenuItem(child: Text('Lato'), value: 'Lato'),
                        ],
                        onChanged: changeFontFamily,
                      ),
                    ),
                  );
                  break;
                case 3:
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Background color'),
                      content: SingleChildScrollView(
                        child: BlockPicker(
                          pickerColor: backgroundColor,
                          onColorChanged: changeBackgroundColor,
                        ),
                      ),
                    ),
                  );
                  break;
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  content,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontFamily: fontFamily,
                    height: 1.5,
                  ),
                ),
              ),
            ),
      backgroundColor: backgroundColor,
    );
  }
}
