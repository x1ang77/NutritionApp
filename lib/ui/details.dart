
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_app/data/model/recipe.dart';

class Details extends StatefulWidget {
  const Details({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late Recipe _recipeData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecipeById();
  }

  Future getRecipeById() async{
    try {
      final documentSnapshot =
      await FirebaseFirestore.instance.collection('meals').doc(widget.id).get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();
        // Assuming you have a Recipe model, you can initialize it with the retrieved data
        setState(() {
          _recipeData = Recipe.fromMap(data!);

        });
        debugPrint("${_recipeData.image}");
      } else {
        print('Document does not exist');
      }
    } catch (error) {
      print('Error fetching document: $error');
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
                    child: Image.asset(_recipeData.thumbnail),
                  ),
                ],
              ),

              Positioned(
                top: 48.0,
                left: 24.0,
                child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      onPressed: () {
                        // FAB onPressed action
                      },
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
                      onPressed: () {
                        // FAB onPressed action
                      },
                      child: const Icon(Icons.book_outlined, color: Colors.red, size: 32,),
                    ),
              ),

            ],
          ),
          const SizedBox(height: 20,),
          Center(
            child: Text(
              _recipeData.name,
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
              _recipeData.desc,
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
                            Text(_recipeData.calories.toString(),
                              style: const TextStyle(
                                  color:Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            const Text("calories",
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
                            Text("${_recipeData.grams}g",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            const Text("grams",
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
                          Text(_recipeData.carbs.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          const Text("carbs",
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
                            Text("${_recipeData.protein}g",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            const Text("protein",
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
                    Expanded(child:
                    Column(
                      children: [
                        SizedBox(height:36, child: ClipOval(
                          child: Image.asset(
                            _recipeData.image![0],
                            fit: BoxFit.cover, // Make the image scale up while maintaining aspect ratio
                          ),
                        ),
                        ),
                        Text(_recipeData.ingredients![0],
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                    ),
                    Expanded(child:
                    Column(
                      children: [
                        SizedBox(height:36, child: ClipOval(
                          child: Image.asset(
                            _recipeData.image![1],
                            fit: BoxFit.cover, // Make the image scale up while maintaining aspect ratio
                          ),
                        ),
                        ),
                        Text(_recipeData.ingredients![1],
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                    ),
                    Expanded(child:
                    Column(
                      children: [
                        SizedBox(height:36, child: ClipOval(
                          child: Image.asset(
                            _recipeData.image![2],
                            fit: BoxFit.cover, // Make the image scale up while maintaining aspect ratio
                          ),
                        ),
                        ),
                        Text(_recipeData.ingredients![2],
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                    ),
                    Expanded(child:
                      Column(
                        children: [
                          SizedBox(height:36, child: ClipOval(
                            child: Image.asset(
                              _recipeData.image![3],
                              fit: BoxFit.cover, // Make the image scale up while maintaining aspect ratio
                            ),
                          ),
                          ),
                          Text(_recipeData.ingredients![3],
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          )
                        ],
                      )
                    ),
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
                  Text("Step 1: ${_recipeData.steps![0]}",
                    style: const TextStyle(
                        fontSize: 16
                    ),
                  ),
                  const SizedBox(height: 2,),
                  Text("Step 2: ${_recipeData.steps![1]}",
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
