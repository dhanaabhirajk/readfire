import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future<String> key_func() async {
  // initialise app based on platform- web or mobile
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCJCIo6-I5aTuMFORO6pfoSYLD6RDbcQo8",
        authDomain: "article-reader-55c5d.firebaseapp.com",
        projectId: "article-reader-55c5d",
        storageBucket: "article-reader-55c5d.appspot.com",
        messagingSenderId: "1029330434048",
        appId: "1:1029330434048:web:f2539009c7288dba8a80e5",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  return "success";
}
