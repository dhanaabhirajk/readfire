import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:readfire/models/article.dart';

import '../utils/colors.dart';

class RelatedArticle extends StatefulWidget {
  final String article_id;
  const RelatedArticle({Key? key, required this.article_id}) : super(key: key);

  @override
  State<RelatedArticle> createState() => _RelatedArticleState();
}

class _RelatedArticleState extends State<RelatedArticle> {
  String get_content(String content) {
    if (content.length > 70) {
      content = content.substring(0, 70) + "...";
    }
    return content;
  }

  String get_title(String title) {
    if (title.length > 25) {
      title = title.substring(0, 26) + "...";
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('articles');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.article_id).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Article article = Article.fromSnap(snapshot.data!);
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: 100,
            color: secondaryColor,
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 20,
                            child: const Icon(
                              Icons.person,
                            ),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(
                                get_title(article.title.trim()),
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(
                                article.author.trim(),
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, "/article",
                              arguments: widget.article_id);
                        }),
                  ],
                ),
                GestureDetector(
                    child: Text(get_content(article.content),
                        style: TextStyle(
                          fontSize: 16,
                        )),
                    onTap: () {
                      Navigator.pushNamed(context, "/article",
                          arguments: widget.article_id);
                    }),
              ],
            ),
          );
        }

        return Text("");
      },
    );
  }
}
