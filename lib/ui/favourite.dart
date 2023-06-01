import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../custom_icons.dart';
import '../data/model/recipe.dart';
import '../data/repository/user/user_repository_impl.dart';

class Favourite extends StatefulWidget {
  const Favourite({Key? key}) : super(key: key);

  @override
  State<Favourite> createState() => _FavouriteState();
}

enum SortType {
  Alphabetical,
  CalorieCount,
}

enum SortOrder {
  Ascending,
  Descending,
}

class _FavouriteState extends State<Favourite> {
  List<Recipe> _allRecipes = [];
  List<Recipe> _filteredRecipes = [];
  bool _isSearching = false;
  var repo = UserRepoImpl();

  @override
  void initState() {
    super.initState();
    getRecipe();
  }

  // Show snackbar when bookmark has been deleted
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
          _filteredRecipes.removeWhere((recipe) => recipe.id == id);
        });
      });
    }
  }

  Future getRecipe() async {
    var user = FirebaseAuth.instance.currentUser?.uid;
    var currentUser = await repo.getUserById(user!);
    var collection = FirebaseFirestore.instance.collection("recipes");
    var querySnapshot = await collection.get();
    for (var item in querySnapshot.docs) {
      var data = item.data();
      var recipe = Recipe.fromMap(data);
      // debugPrint("${recipe.image[0]}");
      if (currentUser!.favourite!.contains(recipe.id)) {
        setState(() {
          _allRecipes.add(recipe);
          _filteredRecipes.add(recipe);
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

  void _filterRecipes(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredRecipes = List.from(
            _allRecipes); // Copy all recipes to the filtered list when the query is empty
      } else {
        _filteredRecipes = _allRecipes.where((recipe) {
          final nameLower = recipe.name.toLowerCase();
          final queryLower = query.toLowerCase();
          return nameLower.contains(queryLower);
        }).toList();
      }
    });
  }

  void _sortRecipes() {
    SortType selectedSortType = SortType.Alphabetical;
    SortOrder selectedSortOrder = SortOrder.Ascending;
    bool hasSorted = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Sort Recipes'),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text('Asc'),
                        leading: Radio<SortOrder>(
                          value: SortOrder.Ascending,
                          groupValue: selectedSortOrder,
                          onChanged: (SortOrder? value) {
                            setState(() {
                              selectedSortOrder = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text('Desc'),
                        leading: Radio<SortOrder>(
                          value: SortOrder.Descending,
                          groupValue: selectedSortOrder,
                          onChanged: (SortOrder? value) {
                            setState(() {
                              selectedSortOrder = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  title: Text('Alphabetical'),
                  leading: Radio<SortType>(
                    value: SortType.Alphabetical,
                    groupValue: selectedSortType,
                    onChanged: (SortType? value) {
                      setState(() {
                        selectedSortType = value!;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text('Calorie Count'),
                  leading: Radio<SortType>(
                    value: SortType.CalorieCount,
                    groupValue: selectedSortType,
                    onChanged: (SortType? value) {
                      setState(() {
                        selectedSortType = value!;
                      });
                    },
                  ),
                ),
              ]),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    _applySort(selectedSortType, selectedSortOrder);
                    Navigator.pop(context);
                    hasSorted = true;
                  },
                  child: Text('Sort'),
                ),
              ],
            );
          },
        );
      },
    );
    if (hasSorted) {
      _showSortSnackBar(selectedSortType, selectedSortOrder);
    }
  }

  void _applySort(SortType sortType, SortOrder sortOrder) {
    setState(() {
      switch (sortType) {
        case SortType.Alphabetical:
          _allRecipes.sort((a, b) => a.name.compareTo(b.name));
          break;
        case SortType.CalorieCount:
          _allRecipes
              .sort((a, b) => (a.calorie ?? 0).compareTo(b.calorie ?? 0));
          break;
      }

      if (sortOrder == SortOrder.Descending) {
        _allRecipes = _allRecipes.reversed.toList();
      }

      _filteredRecipes = List.from(
          _allRecipes); // Update the filtered list with the sorted results
    });

    _showSortSnackBar(sortType, sortOrder);
  }

  void _showSortSnackBar(SortType sortType, SortOrder sortOrder) {
    String snackBarMessage;

    switch (sortType) {
      case SortType.Alphabetical:
        snackBarMessage = 'Recipes sorted by alphabetical order';
        break;
      case SortType.CalorieCount:
        snackBarMessage = 'Recipes sorted by calorie count';
        break;
    }

    if (sortOrder == SortOrder.Descending) {
      snackBarMessage += ' (Descending)';
    } else {
      snackBarMessage += ' (Ascending)';
    }

    final snackBar = SnackBar(
      content: Text(snackBarMessage),
      duration: Duration(seconds: 1),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: _isSearching ? _buildSearchBar() : Text("Bookmarks"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _filterRecipes('');
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              _sortRecipes();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _filteredRecipes.isEmpty
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
                        Text(
                          "My Bookmarks",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
                        ),
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
                                    "${_filteredRecipes.length}",
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
            SizedBox(height: 20), // Add spacing between the title and the list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredRecipes.length,
              itemBuilder: (context, index) {
                final allRecipe = _filteredRecipes[index];
                return Card(
                  color: Color(0xFFFBFBF8),
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  // Adjust margin as needed
                  elevation: 4,
                  // Add elevation for a raised appearance
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
                        Icon(Icons.local_fire_department,
                            size: 16, color: Colors.grey),
                        // Add an icon to represent kcal
                        SizedBox(width: 4),
                        Text("${allRecipe.calorie} kcal",
                            style: TextStyle(fontSize: 12)),
                        // Show the calories value
                        SizedBox(width: 8),
                        // Show the grams value
                      ],
                    ),
                    trailing: GestureDetector(
                      onTap: () => _showDeleteConfirmationDialog(allRecipe),
                      child: const Icon(
                        CustomIcons.trash,
                        color: Colors.grey,
                        size: 20,
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

  Widget _buildSearchBar() {
    return Container(
      child: TextField(
        onChanged: _filterRecipes,
        style: TextStyle(color: Colors.white, fontSize: 20),
        decoration: InputDecoration(
          hintText: "Search",
          hintStyle: TextStyle(color: Colors.white, fontSize: 20),
          prefixIcon: Icon(Icons.search, color: Colors.white),
          // focusedBorder: InputBorder.none, // Remove the bottom line when focused
        ),
        textAlignVertical: TextAlignVertical.center,
      ),
    );
  }
}
