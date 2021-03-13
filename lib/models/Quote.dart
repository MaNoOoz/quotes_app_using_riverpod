import 'package:hive/hive.dart';

part 'Quote.g.dart';

@HiveType(typeId: 0)
class Quote {
  Quote({this.id, this.tags, this.content, this.author, this.length, this.liked});

  @HiveField(0)
  String id;
  @HiveField(1)
  List<String> tags;
  @HiveField(2)
  String content;
  @HiveField(3)
  String author;
  @HiveField(4)
  int length;
  @HiveField(5)
  bool liked;

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
        id: json["_id"],
        tags: List<String>.from(json["tags"].map((x) => x)),
        content: json["content"],
        author: json["author"],
        length: json["length"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "content": content,
        "author": author,
        "length": length,
      };
}
