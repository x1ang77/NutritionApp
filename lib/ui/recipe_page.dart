import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../data/model/recipe.dart';
import '../data/repository/user/user_repository_impl.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({Key? key}) : super(key: key);

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final List<Recipe> _breakfastRecipes = [];
  final List<Recipe> _lunchRecipes = [];
  final List<Recipe> _dinnerRecipes = [];
  int _index = 0;
  var repo = UserRepoImpl();

  @override
  void initState() {
    super.initState();
    getRecipe();
  }

  _navigateToDetails(String id) {
    context.pushNamed("id", pathParameters: {"id": id});
  }

  Future getRecipe() async {
    var collection = FirebaseFirestore.instance.collection("recipes");
    var querySnapshot = await collection.get();
    for (var item in querySnapshot.docs) {
      var data = item.data();
      var recipe = Recipe.fromMap(data);
      setState(() {
        if (recipe.mealTime == "Breakfast") {
          _breakfastRecipes.add(recipe);
        }
        if (recipe.mealTime == "Lunch") {
          _lunchRecipes.add(recipe);
        }
        if (recipe.mealTime == "Dinner") {
          _dinnerRecipes.add(recipe);
        }
      });
    }
  }

  // Add snackbar if user has already bookmarked
  _addToFavourite(String id) async {
    var user = FirebaseAuth.instance.currentUser?.uid;

    DocumentReference documentRef =
        FirebaseFirestore.instance.collection("users").doc(user);
    // Retrieve the document
    var documentSnapshot = await repo.getUserById(user!);

    if (documentSnapshot != null) {
      var array = documentSnapshot.favourite;
      if (array != null) {
        if (!array.contains(id)) {
          documentRef.update({
            'favourite': FieldValue.arrayUnion([id])
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(title: const Text("Recipes"), centerTitle: true),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breakfast Carousel Slider
              const Text(
                "Breakfast",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 215,
                child: CarouselSlider.builder(
                  itemCount: _breakfastRecipes.length,
                  options: CarouselOptions(
                    initialPage: 1,
                    viewportFraction: 0.7,
                    enableInfiniteScroll: false,
                    padEnds: false,
                    enlargeCenterPage: true,
                    enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                    // scrollPhysics: BouncingScrollPhysics(),
                    onPageChanged:
                        (int index, CarouselPageChangedReason reason) {
                      setState(() {
                        _index = index;
                      });
                    },
                  ),
                  itemBuilder: (_, i, __) {
                    return Transform.scale(
                      scale: i == _index ? 1 : 1,
                      child: GestureDetector(
                        onTap: () =>
                            _navigateToDetails(_breakfastRecipes[i].id),
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              SizedBox(
                                height: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                        child: Image.network(_breakfastRecipes[i].thumbnail),
                                    ),
                                    const SizedBox(height: 15),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12), // Adjust the left padding as needed
                                      child: SizedBox(
                                        width: 150, // Set the desired width
                                        child: Text(
                                          _breakfastRecipes[i].name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 30,
                                right: 12,
                                child: GestureDetector(
                                  onTap: () => _addToFavourite(_breakfastRecipes[i].id),
                                  child: const CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.green,
                                    child: Icon(
                                      Icons.book_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Lunch Carousel Slider
              const Text(
                "Lunch",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 215,
                child: CarouselSlider.builder(
                  itemCount: _lunchRecipes.length,
                  options: CarouselOptions(
                    initialPage: 1,
                    viewportFraction: 0.7,
                    enableInfiniteScroll: false,
                    padEnds: false,
                    // scrollPhysics: BouncingScrollPhysics(),
                    onPageChanged:
                        (int index, CarouselPageChangedReason reason) {
                      setState(() {
                        _index = index;
                      });
                    },
                  ),
                  itemBuilder: (_, i, __) {
                    return Transform.scale(
                      scale: i == _index ? 1 : 1,
                      child: GestureDetector(
                        onTap: () =>
                            _navigateToDetails(_lunchRecipes[i].id),
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              SizedBox(
                                height: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                      child: Image.network(_lunchRecipes[i].thumbnail),
                                    ),
                                    const SizedBox(height: 15),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12), // Adjust the left padding as needed
                                      child: SizedBox(
                                        width: 150, // Set the desired width
                                        child: Text(
                                          _lunchRecipes[i].name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 30,
                                right: 12,
                                child: GestureDetector(
                                  onTap: () => _addToFavourite(_lunchRecipes[i].id),
                                  child: const CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.green,
                                    child: Icon(
                                      Icons.book_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Dinner Carousel Slider
              const Text(
                "Dinner",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 215,
                child: CarouselSlider.builder(
                  itemCount: _dinnerRecipes.length,
                  options: CarouselOptions(
                    initialPage: 1,
                    viewportFraction: 0.7,
                    enableInfiniteScroll: false,
                    padEnds: false,
                    // scrollPhysics: BouncingScrollPhysics(),
                    onPageChanged:
                        (int index, CarouselPageChangedReason reason) {
                      setState(() {
                        _index = index;
                      });
                    },
                  ),
                  itemBuilder: (_, i, __) {
                    return Transform.scale(
                      scale: i == _index ? 1 : 1,
                      child: GestureDetector(
                        onTap: () =>
                            _navigateToDetails(_dinnerRecipes[i].id),
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              SizedBox(
                                height: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                      child: Image.network(_dinnerRecipes[i].thumbnail),
                                    ),
                                    const SizedBox(height: 15),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12), // Adjust the left padding as needed
                                      child: SizedBox(
                                        width: 150, // Set the desired width
                                        child: Text(
                                          _dinnerRecipes[i].name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              Positioned(
                                bottom: 30,
                                right: 12,
                                child: GestureDetector(
                                  onTap: () => _addToFavourite(_dinnerRecipes[i].id),
                                  child: const CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.green,
                                    child: Icon(
                                      Icons.book_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
