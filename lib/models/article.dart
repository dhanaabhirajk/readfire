import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  final String title;
  final String content;
  final String author;
  final List<Related> related;

  const Article({
    required this.title,
    required this.content,
    required this.author,
    required this.related,
  });

  static Article fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    var list = snapshot["related"] as List;
    List<Related> relatedList = list.map((i) => Related.fromSnap(i)).toList();
    return Article(
      title: snapshot["title"],
      content: snapshot["content"],
      author: snapshot["author"],
      related: relatedList,
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
        "author": author,
      };
}

class Related {
  final String id;
  final double per;
  const Related({required this.id, required this.per});

  static Related fromSnap(Map<String, dynamic> snapshot) {
    return Related(
      id: snapshot["id"],
      per: snapshot["per"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "per": per,
      };
}
