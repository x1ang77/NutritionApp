import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

import '../data/model/recipe.dart';
import '../data/repository/user/user_repository_impl.dart';

class Favourite extends StatefulWidget {
  const Favourite({Key? key}) : super(key: key);

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  List<Recipe> _allRecipes = [];
  var repo = UserRepoImpl();

  @override
  void initState() {
    super.initState();
    getRecipe();
  }

  _deleteFavourite(String id) async {
    var user = FirebaseAuth.instance.currentUser?.uid;

    DocumentReference documentRef =
        FirebaseFirestore.instance.collection("users").doc(user);
    // Retrieve the document
    var documentSnapshot = await repo.getUserById(user!);

    if (documentSnapshot != null) {
      documentRef.update({
        'favourite': FieldValue.arrayRemove([id])
      }).then((_) {
        setState(() {
          _allRecipes.removeWhere((recipe) => recipe.id == id);
        });
      });
    }
  }

  Future getRecipe() async {
    var user = FirebaseAuth.instance.currentUser?.uid;
    var currentUser = await repo.getUserById(user!);
    var collection = FirebaseFirestore.instance.collection("meals");
    var querySnapshot = await collection.get();
    for (var item in querySnapshot.docs) {
      var data = item.data();
      var recipe = Recipe.fromMap(data);
      debugPrint("${recipe.image?[0]}");
      if (currentUser!.favourite!.contains(recipe.id)) {
        setState(() {
          _allRecipes.add(recipe);
        });
      }
    }
  }

  void _showDeleteConfirmationDialog(Recipe recipe) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this recipe?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteFavourite(recipe.id!);
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bookmarks")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _allRecipes.isEmpty
                ? Container(
                    height: MediaQuery.of(context).size.height - 100,
                    child: const Center(
                      child: Text(
                        "No Favourites",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                : Container(
                    padding: EdgeInsets.only(left: 20, top: 20, right: 20),
                    child: Row(
                      children: [
                        Text("My Bookmarks", style: TextStyle(fontSize: 24)),
                        Spacer(),
                        Stack(
                          children: [
                            const Icon(
                              Icons.bookmark,
                              color: Colors.red,
                              size: 40,
                            ),
                            Positioned(
                              top: 15,
                              left: 0,
                              right: 0,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child: Transform.translate(
                                  offset: Offset(0, -6),
                                  // Adjust the offset as needed
                                  child: Text(
                                    "${_allRecipes.length}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _allRecipes.length,
              itemBuilder: (context, index) {
                final allRecipe = _allRecipes[index];
                return Card(
                  color: Color(0xFFFBFBF8),
                  margin: const EdgeInsets.all(8),
                  elevation: 4, // Add elevation for a raised appearance
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Add rounded corners
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    title: Text(allRecipe.name),
                    subtitle: Row(
                      children: [
                        Text("${allRecipe.carbs} cals"),
                        SizedBox(width: 8),
                        Text("${allRecipe.grams}g"),
                        SizedBox(width: 8),
                        Text("${allRecipe.carbs} carbs"),
                        SizedBox(width: 8),
                        Text("${allRecipe.protein} pro"),
                      ],
                    ),
                    trailing: GestureDetector(
                      onTap: () => _showDeleteConfirmationDialog(allRecipe),
                      child: Icon(
                        Icons.delete_outline_sharp,
                        color: Colors.grey,
                        size: 32,
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
