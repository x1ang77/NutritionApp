class Ingredient {
  final int? id;
  final String name;
  final int calorie;
  final int? weight;
  final int? piece;
  final int? cup;
  final int? teaspoon;

  static const String tableName = "ingredients";

  Ingredient({this.id, required this.name, required this.calorie, this.weight, this.piece, this.cup, this.teaspoon});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "calorie": calorie,
      "weight": weight,
      "piece": piece,
      "cup": cup,
      "teaspoon": teaspoon
    };
  }

  static Ingredient fromMap(Map<String, dynamic> map) {
    return Ingredient(
        id: map["id"],
        name: map["name"],
        calorie: map["calorie"],
        weight: map["weight"],
        piece: map["piece"],
        cup: map["cup"],
        teaspoon: map["teaspoon"],
    );
  }
}
