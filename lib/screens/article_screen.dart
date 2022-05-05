import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:readfire/models/article.dart';
import 'package:readfire/utils/colors.dart';

class ArticleList extends StatefulWidget {
  const ArticleList({Key? key}) : super(key: key);
  @override
  State<ArticleList> createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("readfire")),
        backgroundColor: primaryColor,
        foregroundColor: secondaryColor,
      ),
      body: StreamBuilder<QuerySnapshot<Article>>(
        stream: FirebaseFirestore.instance
            .collection("articles")
            .withConverter<Article>(
              fromFirestore: (snapshots, _) => Article.fromSnap(snapshots),
              toFirestore: (article, _) => article.toJson(),
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.requireData;

          return ListView.builder(
            itemCount: data.size,
            itemBuilder: (context, index) {
              return _ArticleItem(
                data.docs[index].data(),
                data.docs[index].reference,
              );
            },
          );
        },
      ),
    );
  }
}

class _ArticleItem extends StatelessWidget {
  const _ArticleItem(this.article, this.reference);
  final DocumentReference reference;
  final Article article;

  String get_content(String content) {
    if (content.length > 250) {
      content = content.substring(0, 250) + "...";
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 240,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      get_title(article.title.trim()),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(article.author.trim()),
                  ),
                ],
              ),
            ],
          ),
          Text(get_content(article.content),
              style: TextStyle(
                fontSize: 16,
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
                child: Container(
                  width: 200,
                  margin: EdgeInsets.only(bottom: 0),
                  decoration: BoxDecoration(
                      boxShadow: kElevationToShadow[4],
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.arrow_forward),
                          Text(
                            "  Read Full article",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/article",
                      arguments: reference.id);
                }),
          ),
        ],
      ),
    );
  }
}

/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:readfire/models/article.dart';
import 'package:readfire/utils/colors.dart';

class ArticleList extends StatefulWidget {
  const ArticleList({Key? key}) : super(key: key);
  @override
  State<ArticleList> createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("readfire")),
        backgroundColor: primaryColor,
        foregroundColor: secondaryColor,
      ),
      body: StreamBuilder<QuerySnapshot<Article>>(
        stream: FirebaseFirestore.instance
            .collection("articles")
            .withConverter<Article>(
              fromFirestore: (snapshots, _) => Article.fromSnap(snapshots),
              toFirestore: (article, _) => article.toJson(),
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.requireData;

          return ListView.builder(
            itemCount: data.size,
            itemBuilder: (context, index) {
              return _ArticleItem(
                data.docs[index].data(),
                data.docs[index].reference,
              );
            },
          );
        },
      ),
    );
  }
}

class _ArticleItem extends StatelessWidget {
  const _ArticleItem(this.article, this.reference);
  final DocumentReference reference;
  final Article article;

  String get_content(String content) {
    if (content.length > 250) {
      content = content.substring(0, 250) + "...";
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 240,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      get_title(article.title.trim()),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(article.author.trim()),
                  ),
                ],
              ),
            ],
          ),
          Text(get_content(article.content),
              style: TextStyle(
                fontSize: 16,
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 200,
              margin: EdgeInsets.only(bottom: 0),
              decoration: BoxDecoration(
                  boxShadow: kElevationToShadow[4],
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(15)),
              child: GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_forward),
                        Text(
                          "  Read Full article",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "/article",
                        arguments: reference.id);
                  }),
            ),
          ),
        ],
      ),
    );
  }
}


*/