import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  _deleteFavourite(String id)async{
    var user = FirebaseAuth.instance.currentUser?.uid;

    DocumentReference documentRef = FirebaseFirestore.instance.collection("users").doc(user);
    // Retrieve the document
    var documentSnapshot = await repo.getUserById(user!);

    if (documentSnapshot != null) {
        documentRef.update({
          'favourite': FieldValue.arrayRemove([id])
        }).then((_){
          setState(() {
            _allRecipes.removeWhere((recipe) => recipe.id ==id);
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
      if(currentUser!.favourite!.contains(recipe.id)){
        setState(() {
          _allRecipes.add(recipe);
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child:
        Column(
          children: [
            _allRecipes.isEmpty ?
            Container(
              height: MediaQuery.of(context).size.height - 100,
              child: const Center(
                child: Text(
                  "No Favourites",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ) :
            const Text("Favourite"),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _allRecipes.length,
              itemBuilder: (context, index) {
                final allRecipe = _allRecipes[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Text("${allRecipe.name}"),
                              Row(
                                children: [
                                  Text("${allRecipe.carbs} cals"),
                                  Text("${allRecipe.grams}g"),
                                  Text("${allRecipe.carbs} carbs"),
                                  Text("${allRecipe.protein} pro"),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () => _deleteFavourite(allRecipe.id!),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Icon(Icons.delete),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
