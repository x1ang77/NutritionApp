
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrition_app/data/model/recipe.dart';
import 'package:nutrition_app/data/repository/recipe/recipe_repository_impl.dart';
import '../data/model/user.dart' as user_model;
import '../data/repository/user/user_repository_impl.dart';

class Details extends StatefulWidget {
  const Details({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  Recipe? _recipeData;
  var userRepo = UserRepoImpl();
  var recipeRepo = RecipeRepoImpl();

  @override
  void initState() {
    super.initState();
    getRecipeById();
  }

  Future getRecipeById() async{
    try {
      var _recipe = await recipeRepo.getRecipe(widget.id);
      setState(() {
        _recipeData = _recipe;
      });
    } catch (error) {
      debugPrint('Error fetching document: $error');
    }
  }

  _navigateToRecipe(){
    context.pop();
  }

  _addToFavourite(String id) async {
    var user = FirebaseAuth.instance.currentUser?.uid;

    DocumentReference documentRef = FirebaseFirestore.instance.collection("users").doc(user);
    // Retrieve the document
    var documentSnapshot = await userRepo.getUserById(user!);

    if (documentSnapshot != null) {
      var array =documentSnapshot.favourite;
      if(array != null){
        if (!array.contains(id)) {
            documentRef.update({
              'favourite': FieldValue.arrayUnion([id])
            }
          );
        }
      }

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                    child: Image.network(_recipeData?.thumbnail ?? ""),
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
                      onPressed: () => _addToFavourite(widget.id)
                      ,
                      child: const Icon(Icons.book_outlined, color: Colors.red, size: 32,),
                    ),
              ),

            ],
          ),
          const SizedBox(height: 20,),
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
          const SizedBox(height: 20,),
          Center(
            child: Text(
              _recipeData?.description ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 20,),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 30),
            elevation: 10,
            child:
              Column(
                children: [
                  const SizedBox(height: 7,),
                  const Text("Nutritional information",style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(child:
                        Column(
                          children: [
                            Text("${_recipeData?.calorie}",
                              style: const TextStyle(
                                  color:Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            const Text("kcal",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(child:
                        Column(
                          children: [
                            Text("${_recipeData?.carb}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            const Text("Carb (g)",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(child:
                      Column(
                        children: [
                          Text("${_recipeData?.protein}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          const Text("Protein (g)",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                      ),
                      Expanded(child:
                        Column(
                          children: [
                            Text("${_recipeData?.fat}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            const Text("Fat (g)",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            )
                          ],
                        )
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,)
                ],
              ),
          ),
          const SizedBox(height: 30,),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 30),
            elevation: 10,
            child:
            Column(
              children: [
                SizedBox(height: 7,),
                Text("Ingredients",style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text(_recipeData!.ingredients[0],
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                    Text(_recipeData!.ingredients[1],
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Text(_recipeData!.ingredients[2],
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Text(_recipeData!.ingredients[3],
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    // ListView.builder(
                    //     itemBuilder: (BuildContext context, int index) {
                    //       return Column(
                    //         children: [
                    //           // SizedBox(
                    //           //   height:36,
                    //           //   child: ClipOval(
                    //           //     child: Image.asset(
                    //           //       _recipeData.image![0],
                    //           //       fit: BoxFit.cover, // Make the image scale up while maintaining aspect ratio
                    //           //     ),
                    //           //   ),
                    //           // ),
                    //           Text(_recipeData?.ingredients?[index] ?? "",
                    //             style: const TextStyle(
                    //               fontSize: 12,
                    //             ),
                    //           )
                    //         ],
                    //       );
                    //     }),

                    // Expanded(child:
                    //   Column(
                    //     children: [
                    //       SizedBox(height:36, child: ClipOval(
                    //         child: Image.asset(
                    //           _recipeData.image![0],
                    //           fit: BoxFit.cover, // Make the image scale up while maintaining aspect ratio
                    //         ),
                    //       ),
                    //       ),
                    //       Text(_recipeData.ingredients![0],
                    //         style: const TextStyle(
                    //           fontSize: 12,
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    //
                    // Expanded(child:
                    // Column(
                    //   children: [
                    //     SizedBox(height:36, child: ClipOval(
                    //       child: Image.asset(
                    //         _recipeData.image![1],
                    //         fit: BoxFit.cover, // Make the image scale up while maintaining aspect ratio
                    //       ),
                    //     ),
                    //     ),
                    //     Text(_recipeData.ingredients![1],
                    //       style: const TextStyle(
                    //         fontSize: 12,
                    //       ),
                    //     )
                    //   ],
                    // ),
                    // ),
                    // Expanded(child:
                    // Column(
                    //   children: [
                    //     SizedBox(height:36, child: ClipOval(
                    //       child: Image.asset(
                    //         _recipeData.image![2],
                    //         fit: BoxFit.cover, // Make the image scale up while maintaining aspect ratio
                    //       ),
                    //     ),
                    //     ),
                    //     Text(_recipeData.ingredients![2],
                    //       style: const TextStyle(
                    //         fontSize: 12,
                    //       ),
                    //     )
                    //   ],
                    // ),
                    // ),
                    // Expanded(child:
                    //   Column(
                    //     children: [
                    //       SizedBox(height:36, child: ClipOval(
                    //         child: Image.asset(
                    //           _recipeData.image![3],
                    //           fit: BoxFit.cover, // Make the image scale up while maintaining aspect ratio
                    //         ),
                    //       ),
                    //       ),
                    //       Text(_recipeData.ingredients![3],
                    //         style: const TextStyle(
                    //           fontSize: 12,
                    //         ),
                    //       )
                    //     ],
                    //   )
                    // ),
                  ],
                ),
                SizedBox(height: 10,)
              ],
            ),
          ),
          const SizedBox(height: 30,),
          Container(
            width: double.infinity,
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              elevation: 10,
              child:
              Column(
                children: [
                  const SizedBox(height: 7,),
                  const Text("Preparation",style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                  const SizedBox(height: 2,),
                  Text("Step 1: ${_recipeData?.steps[0]}",
                    style: const TextStyle(
                        fontSize: 16
                    ),
                  ),
                  const SizedBox(height: 2,),
                  Text("Step 2: ${_recipeData?.steps[1]}",
                    style: const TextStyle(
                        fontSize: 16
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () {},
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          color: Colors.red, // Set the background color here
                          child: const Text(
                            "See more",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
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
          const SizedBox(height: 30,),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: Colors.green.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Set the desired border radius
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0), // Set the desired padding values
                child: Text(
                  "Add to Log",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
