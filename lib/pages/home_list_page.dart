import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_test/model/add_recipe_model.dart';
import 'package:fire_test/pages/edit_recipe_page.dart';
import 'package:fire_test/pages/recipe_details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class HomeListPage extends StatefulWidget {
  const HomeListPage({super.key});

  @override
  State<HomeListPage> createState() => _HomeListPageState();
}

final userCredential = FirebaseAuth.instance;

class _HomeListPageState extends State<HomeListPage> {
  String? uid;
  DocumentSnapshot? documentSnapshot;

  // Future<void> _auth() async {
  //   try {
  //     final userCredential = await FirebaseAuth.instance.signInAnonymously();
  //     developer.log("Signed in with temporary account.${userCredential}");
  //   } on FirebaseAuthException catch (e) {
  //     switch (e.code) {
  //       case "operation-not-allowed":
  //         developer.log("Anonymous auth hasn't been enabled for this project.");
  //         break;
  //       default:
  //         developer.log("Unknown error.");
  //     }
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // _auth();
    if (uid != null) return;
    uid = userCredential.currentUser!.uid.toString();
  }

  // Future<void> _delete(String recipeId) async {
  //   CollectionReference usersPost =
  //       FirebaseFirestore.instance.collection('recipePost');
  //   await usersPost.doc(recipeId).delete();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: GestureDetector(
        //   onTap: () {
        //     Navigator.of(context)
        //         .pushNamedAndRemoveUntil("/add_recipe_page/", (route) => false);
        //   },
        //   child: const Icon(
        //     Icons.home_outlined, // add custom icons also
        //   ),
        // ),
        title: const Text("My Post"),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.save_outlined,
        //         color: Colors.white, size: 30.0),
        //     onPressed: () {
        //       // Navigator.of(context)
        //       //     .pushNamedAndRemoveUntil("/login_page/", (route) => false);
        //     },
        //   ),
        // ],
      ),
      body: StreamBuilder<List<RecipeModel>>(
        stream: getAllRecipe(),
        builder: (context, snapshots) {
          if (snapshots.hasData) {
            // final recipeData = snapshots.data!;
            // final recipeData = snapshots.data!;

            return ListView.builder(
                itemCount: snapshots.data!.length,
                itemBuilder: (context, index) {
                  var recipeData = snapshots.data![index];
                  return uid != null
                      ? uid == recipeData.userId
                          ? Card(
                              clipBehavior: Clip.hardEdge,
                              child: SizedBox(
                                width: 300,
                                height: 370,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      splashColor: Colors.blue.withAlpha(30),
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RecipeDetailsPage(
                                              imageURL: recipeData.imageURL,
                                              recipeIngredients:
                                                  recipeData.recipeIngredients,
                                              recipeInstructions:
                                                  recipeData.recipeInstructions,
                                              recipeName: recipeData.recipeName,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 280,
                                        width: 280,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          image: const DecorationImage(
                                              image:
                                                  AssetImage('assets/food.jpg'),
                                              fit: BoxFit.fill),
                                        ),
                                        child: recipeData.imageURL == ""
                                            ? const Text("")
                                            : Image.network(
                                                recipeData.imageURL,
                                                fit: BoxFit.fill,
                                              ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            recipeData.recipeName,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 23,
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditRecipePage(
                                                    imageURL:
                                                        recipeData.imageURL,
                                                    recipeIngredients:
                                                        recipeData
                                                            .recipeIngredients,
                                                    recipeInstructions:
                                                        recipeData
                                                            .recipeInstructions,
                                                    recipeName:
                                                        recipeData.recipeName,
                                                    recipeId:
                                                        recipeData.recipeId,
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const Text("")
                      : const Text("data");
                });
          } else if (snapshots.hasData) {
            return Center(child: Text(" ${snapshots.error}"));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Stream<List<RecipeModel>> getAllRecipe() => FirebaseFirestore.instance
      .collection("recipePost")
      .orderBy("timestamp", descending: true)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => RecipeModel.fromJson(doc.data()))
            .toList(),
      );
}
