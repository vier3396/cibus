import 'add_recipe_form.dart';
import 'ingredients.dart';

class RecipeFormData {
  String title;
  String description;
  List<Ingredient> ingredients;
  List<String> steps;

  RecipeFormData({
    this.description,
    this.ingredients,
    this.steps,
    this.title
});
}