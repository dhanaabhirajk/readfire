import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:readfire/models/article.dart';
import 'package:readfire/screens/recommend.dart';

import '../utils/colors.dart';

class ArticleView extends StatefulWidget {
  final String article_id;
  const ArticleView({Key? key, required this.article_id}) : super(key: key);

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  String get_content(String content) {
    content = "       " + content;
    return content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("readfire")),
        backgroundColor: primaryColor,
        foregroundColor: secondaryColor,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('articles')
            .doc(widget.article_id)
            .get(),
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
            return ListView(
              children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      height: 600,
                      color: secondaryColor,
                      child: ListView(
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              article.title.trim(),
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Text(get_content(article.content),
                              style: TextStyle(
                                fontSize: 16,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Related Articles",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    recommendation(article: article),
                  ],
                )
              ],
            );
          }

          return Text("");
        },
      ),
    );
  }
}

//scrollDirection: Axis.vertical,
//shrinkWrap: true,
//recommendation(article: article),
class recommendation extends StatelessWidget {
  const recommendation({
    Key? key,
    required this.article,
  }) : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108.0 * article.related.length,
      child: Container(
        child: StreamBuilder<String>(
            stream: null,
            builder: (context, snapshot) {
              return ListView.builder(
                itemCount: article.related.length,
                itemBuilder: (context, index) {
                  return RelatedArticle(article_id: article.related[index].id);
                },
              );
            }),
      ),
    );
  }
}

/*
*/