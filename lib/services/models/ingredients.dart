class Ingredient {
  String ingredientName;
  String ingredientId;
  String quantityType;
  int quantity;

  Ingredient(
      {this.ingredientName,
      this.quantity,
      this.quantityType,
      this.ingredientId});

  Map<String, dynamic> ingredientsToMap() => {
    'ingredientName': this.ingredientName,
    'ingredientId': this.ingredientId,
    'quantityType' : this.quantityType,
    'quantity': this.quantity,

  };
}
