// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecipeDetailsPage extends StatelessWidget {
  final String recipeName;
  final String recipeIngredients;
  final String recipeInstructions;
  // final Timestamp timestamp;
  // final String userId;
  final String imageURL;

  const RecipeDetailsPage(
      {super.key,
      required this.recipeName,
      required this.recipeIngredients,
      required this.recipeInstructions,
      required this.imageURL});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipe Details"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              width: 300,
              // height: 580,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 18,
                    ),
                    Container(
                      height: 280,
                      width: 280,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        image: const DecorationImage(
                            image: AssetImage('assets/food.jpg'),
                            fit: BoxFit.fill),
                      ),
                      child: Image.network(
                        imageURL,
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            recipeName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            "Ingredients",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            recipeIngredients,
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            "Instructions",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            recipeInstructions,
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
