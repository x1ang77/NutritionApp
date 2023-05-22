class Ingredient {
  final String? id;
  final String name;
  final double calorie;
  final double? weight;
  final int? piece;
  final int? cup;
  final int? teaspoon;

  static const String tableName = "ingredients";

  Ingredient({this.id, required this.name, required this.calorie, this.weight = 0, this.piece = 0, this.cup = 0, this.teaspoon = 0});

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
