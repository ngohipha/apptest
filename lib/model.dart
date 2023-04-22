import 'dart:convert';

// chapter.dart
List<Chapter> chapterFromJson(String str) =>
    List<Chapter>.from(json.decode(str).map((x) => Chapter.fromJson(x)));

String chapterToJson(List<Chapter> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Chapter {
  int? id;
  String? header;
  String? slug;
  int? viewCount;
  DateTime? updatedDate;
  Story? story;
  List<String>? body;

  Chapter(
      {this.id,
      this.header,
      this.slug,
      this.viewCount,
      this.updatedDate,
      this.story,
      this.body});

  Chapter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    header = json['header'];
    slug = json['slug'];
    viewCount = json['viewCount'];
    updatedDate =
        DateTime.parse(json['updatedDate']); // parse string to DateTime
    story = json['story'] != null ? Story?.fromJson(json['story']) : null;
    body = List<String>.from(json['body'] ?? []);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['header'] = header;
    data['slug'] = slug;
    data['viewCount'] = viewCount;
    data['updatedDate'] = updatedDate;
    data['story'] = story!.toJson();
    data['body'] = body;
    return data;
  }
}

List<Category> categoryFromJson(String str) =>
    List<Category>.from(json.decode(str).map((x) => Category.fromJson(x)));

String categoryToJson(List<Category> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Category {
  Category({
    required this.id,
    required this.title,
    required this.author,
    required this.slug,
    required this.description,
    required this.poster,
    required this.categoryList,
    required this.status,
    required this.uploadDate,
    required this.updatedDate,
    this.deletedAt,
  });

  int id;
  String title;
  String author;
  String slug;
  List<String> description;
  String poster;
  List<String> categoryList;
  Status status;
  DateTime uploadDate;
  DateTime updatedDate;
  dynamic deletedAt;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        title: json["title"],
        author: json["author"],
        slug: json["slug"],
        description: List<String>.from(json["description"].map((x) => x)),
        poster: json["poster"],
        categoryList: List<String>.from(json["categoryList"].map((x) => x)),
        status: statusValues.map[json["status"]]!,
        uploadDate: DateTime.parse(json["uploadDate"]),
        updatedDate: DateTime.parse(json["updatedDate"]),
        deletedAt: json["deletedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "author": author,
        "slug": slug,
        "description": List<dynamic>.from(description.map((x) => x)),
        "poster": poster,
        "categoryList": List<dynamic>.from(categoryList.map((x) => x)),
        "status": statusValues.reverse[status],
        "uploadDate": uploadDate.toIso8601String(),
        "updatedDate": updatedDate.toIso8601String(),
        "deletedAt": deletedAt,
      };
}

enum Status { ANG_RA, FULL }

final statusValues =
    EnumValues({"Đang ra": Status.ANG_RA, "Full": Status.FULL});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

class Story {
  int? id;
  String? slug;

  Story({this.id, this.slug});

  Story.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['slug'] = slug;
    return data;
  }
}
