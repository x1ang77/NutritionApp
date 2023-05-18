import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  const Details({Key? key}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
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
                    child: Image.asset("assets/images/fruit2.jpg"),
                  ),
                ],
              ),

              Positioned(
                top: 48.0,
                left: 24.0,
                child:
                GestureDetector(
                  onTap: () {},
                  child:
                    FloatingActionButton(
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
                )
              ),

              Positioned(
                top: 48.0,
                right: 24.0,
                child:
                GestureDetector(
                  onTap: () {},
                  child:
                    FloatingActionButton(
                      backgroundColor: Colors.white,
                      onPressed: () {
                        // FAB onPressed action
                      },
                      child: const Icon(Icons.book_outlined, color: Colors.red, size: 32,),
                    ),
                )
              ),

            ],
          ),
          const SizedBox(height: 20,),
          const Center(
            child: Text(
              "Yogurt with fruits",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 20,),
          const Center(
            child: Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Aliquam vestibulum morbi blandit cursus risus.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 20,),
          const Card(
            margin: EdgeInsets.symmetric(horizontal: 30),
            elevation: 10,
            child:
              Column(
                children: [
                  SizedBox(height: 7,),
                  Text("Nutritional information",style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(child:
                        Column(
                          children: [
                            Text("243",
                              style: TextStyle(
                                  color:Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            Text("calories",
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
                            Text("2.8g",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            Text("grams",
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
                          Text("167.5",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Text("carbs",
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
                            Text("9.3g",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            Text("protein",
                              style: TextStyle(
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
          const Card(
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
                        Text("243",
                          style: TextStyle(
                              color:Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        Text("calories",
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
                        Text("2.8g",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        Text("grams",
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
                        Text("167.5",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        Text("carbs",
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
                          Text("9.3g",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Text("protein",
                            style: TextStyle(
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
                  const Text("Step 1: Cut Fruits",
                    style: TextStyle(
                        fontSize: 16
                    ),
                  ),
                  const SizedBox(height: 2,),
                  const Text("Step 2: Cut Fruits",
                    style: TextStyle(
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
