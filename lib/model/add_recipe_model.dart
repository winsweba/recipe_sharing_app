import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeModel {
  final String recipeName;
  final String recipeIngredients;
  final String recipeInstructions;
  final Timestamp timestamp;
  final String userId;
  final String imageURL;
  final String recipeId;

  RecipeModel(
      {required this.imageURL,
      required this.userId,
      required this.recipeName,
      required this.recipeIngredients,
      required this.recipeInstructions,
      required this.timestamp,
      required this.recipeId});

  Map<String, dynamic> toJson() => {
        'imageURL': imageURL,
        'recipeName': recipeName,
        "recipeIngredients": recipeIngredients,
        "timestamp": timestamp,
        "recipeInstructions": recipeInstructions,
        "userId": userId,
        "recipeId": recipeId
      };

  static RecipeModel fromJson(Map<String, dynamic> json) => RecipeModel(
      imageURL: json['imageURL'],
      recipeName: json['recipeName'],
      recipeIngredients: json['recipeIngredients'],
      recipeInstructions: json['recipeInstructions'],
      timestamp: json['timestamp'],
      userId: json['userId'],
      recipeId: json['recipeId']);
}
