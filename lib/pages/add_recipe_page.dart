import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_test/model/add_recipe_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as developer;

import 'home_list_page.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({
    super.key,
  });

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String fileUrl = "";
  // var logger = Logger();

  TextEditingController recipeNameTextEditingController =
      TextEditingController();
  TextEditingController recipeIngredientsTextEditingController =
      TextEditingController();
  TextEditingController recipeInstructionsTextEditingController =
      TextEditingController();

  File? _imageFile;

  Future<void> _galleryImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    final imageTemp = File(image.path);
    setState(() {
      _imageFile = imageTemp;
    });
  }

  Future<void> _cameraImage() async {
    final ImagePicker picker = ImagePicker();
// Capture a photo.
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo == null) {
      return;
    }
    final imageTemp = File(photo.path);
    setState(() {
      _imageFile = imageTemp;
    });
  }

  Future<void> _addToFirebase() async {
    // Future<void> _addToFirebase(BuildContext context, VoidCallback onSuccess) async {
    if (!_formKey.currentState!.validate()) return;
    String recipeName = recipeNameTextEditingController.value.text.trim();
    String recipeIngredients =
        recipeIngredientsTextEditingController.value.text.trim();
    String recipeInstructions =
        recipeInstructionsTextEditingController.value.text.trim();

    setState(() {
      _loading = true;
    });

    String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();
    // File path
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirToFile = referenceRoot.child("recipeFiles");
    // the real file to storage
    Reference referenceFileToUpload = referenceDirToFile.child(uniqueFileName);

    CollectionReference usersPost =
        FirebaseFirestore.instance.collection('recipePost');
    String recipeId = usersPost.doc().id;

    FirebaseAuth auth = FirebaseAuth.instance;
    String? uid = auth.currentUser?.uid;

    final timestamp = Timestamp.now();
    // final timestamp = FieldValue.serverTimestamp();

    try {
      await referenceFileToUpload.putFile(_imageFile!);

      fileUrl = await referenceFileToUpload.getDownloadURL();

      final recipeModel = RecipeModel(
        userId: uid!,
        recipeName: recipeName,
        recipeIngredients: recipeIngredients,
        recipeInstructions: recipeInstructions,
        timestamp: timestamp,
        imageURL: fileUrl,
        recipeId: recipeId,
      );

      final jsonData = recipeModel.toJson();

      await usersPost.doc(recipeId).set(jsonData);

      Fluttertoast.showToast(
          msg: "Added Successfully ",
          // msg: "${e.toString().replaceRange(0, 14, '').split(']')[1]}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      developer.log("message Successfully");
    } catch (e) {
      developer.log("message error:: $e");
      Fluttertoast.showToast(
          msg: "Please check Your internet connection ",
          // msg: "${e.toString().replaceRange(0, 14, '').split(']')[1]}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    setState(() {
      _loading = false;
      _imageFile = null;
      recipeNameTextEditingController.text = "";
      recipeIngredientsTextEditingController.text = "";
      recipeInstructionsTextEditingController.text = "";
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    recipeNameTextEditingController.dispose();
    recipeIngredientsTextEditingController.dispose();
    recipeInstructionsTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //       "/home_list_page/", (route) => false);

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const HomeListPage(),
              ),
            );
          },
          child: const Icon(Icons.save_outlined, size: 30.0),
        ),
        title: const Text("Add Recipe"),
        actions: [
          IconButton(
            icon: const Icon(Icons.post_add_sharp,
                color: Colors.white, size: 30.0),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  "/post_list_page/", (route) => false);
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 12,
              ),
              Container(
                height: 280,
                width: 280,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                      image: AssetImage('assets/food.jpg'), fit: BoxFit.fill),
                ),
                child: _imageFile == null
                    // child: _isVideo ? VideoPlayer(_controller!) : _pickFile == null
                    ? const Text("")
                    : Image.file(
                        _imageFile!,
                        fit: BoxFit.fill,
                      ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('please pick an image'),
                    content: const Text('please pick an image'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          _cameraImage();
                          Navigator.pop(context, 'OK');
                        },
                        child: const Icon(Icons.camera_alt_outlined),
                      ),
                      TextButton(
                        onPressed: () {
                          _galleryImage();
                          Navigator.pop(context, 'OK');
                        },
                        child: const Icon(Icons.image_outlined),
                      ),
                    ],
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13.0)),
                  foregroundColor: Colors.white,
                ),
                child: const Text("pick image"),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: recipeNameTextEditingController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "recipe name is empty";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: "recipe name",
                          hintText: "recipe name",
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Colors.amberAccent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3,
                              color: Colors.amberAccent,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: recipeIngredientsTextEditingController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "recipe ingredients is empty";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: "recipe ingredients",
                          hintText: "recipe ingredients",
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.amberAccent),
                              borderRadius: BorderRadius.circular(8.0)),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3,
                              color: Colors.amberAccent,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: recipeInstructionsTextEditingController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "recipe instructions is empty";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.multiline,
                        maxLines: 8,
                        decoration: InputDecoration(
                          labelText: "recipe instructions",
                          hintText: "recipe instructions",
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.amberAccent),
                              borderRadius: BorderRadius.circular(8.0)),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3,
                              color: Colors.amberAccent,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // ElevatedButton(
                    //   onPressed: () {},
                    //   style: ElevatedButton.styleFrom(
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: 30.0, vertical: 10.0),
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(13.0)),
                    //     foregroundColor: Colors.white,
                    //   ),
                    //   child: const Text("Save"),
                    // ),
                    // const SizedBox(
                    //   width: 10,
                    // ),
                    ElevatedButton(
                      onPressed: () {
                        //      await _addToFirebase(context, () {
                        //       if(!mounted) return;
                        // //       Navigator.of(context).pushNamedAndRemoveUntil(
                        // // "/post_list_page/", (route) => false);
                        // Navigator.of(context).pop();
                        //      });

                        _addToFirebase();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13.0)),
                        foregroundColor: Colors.white,
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text("Save and post"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
