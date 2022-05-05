import 'package:flutter/material.dart';
import 'package:readfire/screens/Article_view.dart';
import 'package:readfire/utils/colors.dart';
import 'package:readfire/utils/key.dart';

import 'screens/article_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final res = await key_func();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'readfire',
      theme: ThemeData(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      home: const ArticleList(),
      onGenerateRoute: (settings) {
        List<String> pathComponents = settings.name!.split('/');
        final args = settings.arguments as String;
        //article/L1oTvamoCndM7wLYvQ4S

        if (pathComponents[1] == "article" && args.length > 10) {
          print(pathComponents);
          return MaterialPageRoute(builder: (context) {
            return ArticleView(
              article_id: args,
            );
          });
        }
        if (pathComponents[1] == "article" &&
            pathComponents.last != "article") {
          return MaterialPageRoute(builder: (context) {
            return ArticleView(article_id: pathComponents.last);
          });
        }
        if (pathComponents.last == "article") {
          return MaterialPageRoute(builder: (context) {
            return ArticleList();
          });
        }
      },
    );
  }
}

/*

        if (pathComponents[1] == 'article') {
          return MaterialPageRoute(
            builder: (context) {
              if (pathComponents.last != "article") {
                return ArticleView(article_id: pathComponents.last);
              }
              return ArticleView(article_id: args);
            },
          );
        } else
          return MaterialPageRoute(
            builder: (context) {
              return ArticleList();
            },
          );
*/