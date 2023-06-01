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
  List<Recipe> _allRecipes = [];
  List<Recipe> _breakfastRecipes = [];
  List<Recipe> _lunchRecipes = [];
  List<Recipe> _dinnerRecipes = [];
  int _index = 0;
  var repo = UserRepoImpl();

  // void initFakeData() async {
  //   _allRecipes = [
  //     Recipe(
  //       id: "6",
  //       name: "Fake Recipe 6",
  //       thumbnail: "assets/images/nuts.jpg",
  //       mealTime: "afternoon",
  //       description: 'wadwadaw',
  //       calorie: 250,
  //       carb: 30,
  //       protein: 15,
  //       ingredients: [
  //         'Ingredient 1',
  //         'Ingredient 2',
  //         'Ingredient 3',
  //         'Ingredient 4'
  //       ],
  //       steps: [
  //         'Step 1: Do this',
  //         'Step 2: Do that',
  //         'Step 1: Do this',
  //         'Step 2: Do that'
  //       ],
  //       // image: [
  //       //   "assets/images/nuts.jpg",
  //       //   "assets/images/nuts.jpg",
  //       //   "assets/images/nuts.jpg",
  //       //   "assets/images/nuts.jpg"
  //       // ],
  //     ),
  //   ];
  //
  //   try {
  //     final collectionRef = FirebaseFirestore.instance.collection('meals');
  //
  //     for (final recipe in _allRecipes) {
  //       final recipeMap = recipe.toMap(); // Convert the Recipe object to a Map
  //
  //       await collectionRef.doc(recipe.id).set(recipeMap);
  //     }
  //
  //     print('Fake recipes added to Firestore successfully.');
  //   } catch (error) {
  //     print('Error adding fake recipes to Firestore: $error');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    getRecipe();
    // initFakeData();
  }

  _navigateToDetails(String id) {
    context.pushNamed("id", pathParameters: {"id": id});
  }

  Future getRecipe() async {
    var collection = FirebaseFirestore.instance.collection("recipes");
    // var collection = FirebaseFirestore.instance.collection("recipes");
    var querySnapshot = await collection.get();
    for (var item in querySnapshot.docs) {
      var data = item.data();
      var recipe = Recipe.fromMap(data);
      // debugPrint("${recipe.image?[0]}");
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
        _allRecipes.add(recipe);
      });
    }
  }

  // Future getRecipe() async {
  //   var collection = FirebaseFirestore.instance.collection("meals");
  //   var querySnapshot = await collection.get();
  //   setState(() {
  //     _allRecipes = querySnapshot.docs.map((doc) {
  //       var data = doc.data();
  //       return Recipe.fromMap(data);
  //     }).toList();
  //   });
  // }


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
      appBar: AppBar(title: Text("Recipes"), centerTitle: true),
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
                            _navigateToDetails(_breakfastRecipes[i].id!),
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
                                        child: Image.network(_breakfastRecipes[i].thumbnail ?? ""),
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                    ),
                                    SizedBox(height: 15),
                                    Padding(
                                      padding: EdgeInsets.only(left: 12), // Adjust the left padding as needed
                                      child: Container(
                                        width: 150, // Set the desired width
                                        child: Text(
                                          _breakfastRecipes[i].name ?? "",
                                          style: TextStyle(
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
                                  onTap: () => _addToFavourite(_breakfastRecipes[i].id!),
                                  child: CircleAvatar(
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
                            _navigateToDetails(_lunchRecipes[i].id!),
                        child: Container(
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: ClipRRect(
                                      child: Image.network(_lunchRecipes[i].thumbnail ?? "", fit: BoxFit.fill,),
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                    ),
                                  ),

                                  SizedBox(height: 15,),

                                  Expanded(
                                    child: Text(_lunchRecipes[i].name ?? "",
                                          style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                                    softWrap: false,
                                    ),
                                  ),

                                  // Stack(
                                  //   children: [
                                  //     SizedBox(
                                  //       child: ClipRRect(
                                  //         child: Image.network(_lunchRecipes[i].thumbnail ?? ""),
                                  //         borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                  //       ),
                                  //     ),
                                  //
                                  //     Column(
                                  //       children: [
                                  //         Padding(
                                  //           padding: EdgeInsets.only(left: 12), // Adjust the left padding as needed
                                  //           child: Container(
                                  //             width: 150, // Set the desired width
                                  //             child: Text(
                                  //               _lunchRecipes[i].name ?? "",
                                  //               style: TextStyle(
                                  //                 fontSize: 16,
                                  //                 fontWeight: FontWeight.w600,
                                  //               ),
                                  //               overflow: TextOverflow.ellipsis,
                                  //               softWrap: false,
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //     // SizedBox(
                                  //     //   // height: double.infinity,
                                  //     //   child: Column(
                                  //     //     mainAxisAlignment: MainAxisAlignment.start,
                                  //     //     crossAxisAlignment: CrossAxisAlignment.start,
                                  //     //     children: [
                                  //     //       ClipRRect(
                                  //     //         child: Image.network(_lunchRecipes[i].thumbnail ?? ""),
                                  //     //         borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                  //     //       ),
                                  //     //       SizedBox(height: 15),
                                  //     //       Padding(
                                  //     //         padding: EdgeInsets.only(left: 12), // Adjust the left padding as needed
                                  //     //         child: Container(
                                  //     //           width: 150, // Set the desired width
                                  //     //           child: Text(
                                  //     //             _lunchRecipes[i].name ?? "",
                                  //     //             style: TextStyle(
                                  //     //               fontSize: 16,
                                  //     //               fontWeight: FontWeight.w600,
                                  //     //             ),
                                  //     //             overflow: TextOverflow.ellipsis,
                                  //     //             softWrap: false,
                                  //     //           ),
                                  //     //         ),
                                  //     //       ),
                                  //     //     ],
                                  //     //   ),
                                  //     // ),
                                  //
                                  //     Positioned(
                                  //       bottom: 30,
                                  //       right: 12,
                                  //       child: GestureDetector(
                                  //         onTap: () => _addToFavourite(_lunchRecipes[i].id!),
                                  //         child: CircleAvatar(
                                  //           radius: 20,
                                  //           backgroundColor: Colors.green,
                                  //           child: Icon(
                                  //             Icons.book_outlined,
                                  //             color: Colors.white,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
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
                            _navigateToDetails(_dinnerRecipes[i].id!),
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
                                      child: Image.network(_dinnerRecipes[i].thumbnail ?? ""),
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                    ),
                                    SizedBox(height: 15),
                                    Padding(
                                      padding: EdgeInsets.only(left: 12), // Adjust the left padding as needed
                                      child: Container(
                                        width: 150, // Set the desired width
                                        child: Text(
                                          _dinnerRecipes[i].name ?? "",
                                          style: TextStyle(
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
                              SizedBox(height: 15),
                              Positioned(
                                bottom: 30,
                                right: 12,
                                child: GestureDetector(
                                  onTap: () => _addToFavourite(_dinnerRecipes[i].id!),
                                  child: CircleAvatar(
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
            ],
          ),
        ),
      ),
    );
  }
}
