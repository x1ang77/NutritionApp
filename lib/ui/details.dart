import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nutrition_app/data/model/recipe.dart';
import 'package:nutrition_app/data/repository/diary/diary_repository_impl.dart';
import 'package:nutrition_app/data/repository/recipe/recipe_repository_impl.dart';
import '../data/model/user.dart' as user_model;
import '../data/repository/user/user_repository_impl.dart';
import 'component/snackbar.dart';

class Details extends StatefulWidget {
  const Details({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  var userRepo = UserRepoImpl();
  var recipeRepo = RecipeRepoImpl();
  var diaryRepo = DiaryRepoImpl();

  user_model.User? _user;
  Recipe? _recipeData;
  List<String> meals = [];
  bool isLoading = false;

  Future getUser() async {
    isLoading = true;
    User? user = FirebaseAuth.instance.currentUser;
    var currentUser = await userRepo.getUserById(user?.uid ?? "");
    setState(() {
      _user = currentUser;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getRecipeById();
    getUser();
  }

  Future getRecipeById() async {
    try {
      var _recipe = await recipeRepo.getRecipe(widget.id);
      setState(() {
        _recipeData = _recipe;
      });
    } catch (error) {
      debugPrint('Error fetching document: $error');
    }
  }

  _navigateToRecipe() {
    context.pop();
  }

  Future _addMealToDiary(String id) async {
    try {
      var date = DateFormat.yMd().format(DateTime.now());
      setState(() {
        meals.add(id);
      });
      await diaryRepo.addToDiary(
          _user?.id ?? "",
          date,
          meals,
          _user?.calorieGoal ?? 0.0,
          _user?.carbGoal ?? 0.0,
          _user?.proteinGoal ?? 0.0,
          _user?.fatGoal ?? 0.0,
          id);
      setState(() {
        showSnackbar(context, "Added meal to diary", Colors.green);
      });
    } catch (e) {
      debugPrint(e.toString());
      showSnackbar(context, "Failed to add meal to diary", Colors.red);
    }
  }

  void showFullStepsDialog(BuildContext context, List<String> steps) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: Text(
                          "Full Steps",
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: steps.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            "Step ${index + 1}: ${steps[index]}",
                            style: const TextStyle(fontSize: 16),
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
      },
    );
  }

  _addToFavourite(String id) async {
    var user = FirebaseAuth.instance.currentUser?.uid;

    if (user != null) {
      DocumentReference documentRef =
      FirebaseFirestore.instance.collection("users").doc(user);
      // Retrieve the document
      var documentSnapshot = await userRepo.getUserById(user);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      child: !isLoading ? Image.network(_recipeData?.thumbnail ?? "") : Image.asset("assets/images/placeholder_image.png"),
                    ),
                  ],
                ),
                Positioned(
                  top: 48.0,
                  left: 24.0,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () => _navigateToRecipe(),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.red,
                      size: 32,
                    ),
                  ),
                ),
                Positioned(
                  top: 48.0,
                  right: 24.0,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () => _addToFavourite(widget.id),
                    child: const Icon(
                      Icons.book_outlined,
                      color: Colors.red,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                _recipeData?.name ?? "",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Text(
                  _recipeData?.description ?? "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              elevation: 10,
              child: Column(
                children: [
                  const SizedBox(
                    height: 7,
                  ),
                  const Text(
                    "Nutritional information",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "${_recipeData?.calorie}",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            const Text(
                              "kcal",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "${_recipeData?.carb}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const Text(
                              "Carb (g)",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "${_recipeData?.protein}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const Text(
                              "Protein (g)",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: Column(
                        children: [
                          Text(
                            "${_recipeData?.fat}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const Text(
                            "Fat (g)",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          )
                        ],
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              elevation: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      "Ingredients",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(color: Colors.grey),
                  GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 20),
                    ),
                    itemCount: ((_recipeData?.ingredients.length ?? 0) / 2).ceil(),
                    itemBuilder: (BuildContext context, int index) {
                      final startIndex = index * 2;
                      final endIndex = startIndex + 1;
                      final ingredient1 = "• ${_recipeData?.ingredients[startIndex]}";
                      final ingredient2 =
                          (_recipeData?.ingredients != null && endIndex < (_recipeData?.ingredients.length ?? 0))
                              ? "• ${_recipeData?.ingredients[endIndex]}"
                              : null;
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 2,
                                  ),
                                  child: Text(
                                    ingredient1,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                              if (ingredient2 != null)
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 2,
                                    ),
                                    child: Text(
                                      ingredient2,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: double.infinity,
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                elevation: 10,
                child: Column(
                  children: [
                    const SizedBox(height: 7),
                    const Text(
                      "Preparation",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: (_recipeData?.steps ?? [])
                          .sublist(0, _recipeData?.steps.length.clamp(0, 2))
                          .map(
                            (step) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                              child: Text(
                                "Step ${(_recipeData?.steps.indexOf(step) ?? 0) + 1}: $step",
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    if ((_recipeData?.steps.length ?? 0) > 2)
                      Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () => {},
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(),
                            child: Center(
                              child: TextButton(
                                onPressed: () {
                                  {
                                    showFullStepsDialog(
                                        context, _recipeData?.steps ?? []);
                                  }
                                },
                                child: const Text(
                                  "  See More...",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
              child: ElevatedButton(
                onPressed: () {
                  _addMealToDiary(widget.id);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10), // Set the desired border radius
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  // Set the desired padding values
                  child: Text(
                    "Add to Diary",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
