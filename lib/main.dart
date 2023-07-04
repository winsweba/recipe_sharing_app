import 'package:fire_test/pages/add_recipe_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'pages/home_list_page.dart';
import 'pages/post_list_page.dart';
// import 'pages/recipe_details_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const PostListPage(),
      routes: {
        '/add_recipe_page/': (context) => const AddRecipePage(),
        '/post_list_page/': (context) => const PostListPage(),
        '/home_list_page/': (context) => const HomeListPage(),
      },
    );
  }
}
