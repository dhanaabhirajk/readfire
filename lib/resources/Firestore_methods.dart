import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/article.dart';

class FirestoreMethods {
  Future<Article> getArticle(String article_id) async {
    final doc = await FirebaseFirestore.instance
        .collection('articles')
        .doc(article_id)
        .get();
    return Article.fromSnap(doc);
  }
}
