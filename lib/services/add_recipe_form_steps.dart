import 'package:cibus/services/recipe.dart';
import 'package:flutter/material.dart';
import 'my_text_form_field.dart';

class AddRecipeSteps extends StatefulWidget {
  @override
  _AddRecipeStepsState createState() => _AddRecipeStepsState();
}

class _AddRecipeStepsState extends State<AddRecipeSteps> {
  int steps = 1;

  List<Widget> buildSteps() {
    List<Widget> listOfSteps = [];

    for (int i = 1; i <= steps; i++)
      listOfSteps.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: MyTextFormField(
          labelText: "Step $i",
          validator: (String step) {
            if (step.isEmpty) {
              return 'Enter a Description';
            }
            else {
              //we want to use formKey from AddRecipeForm class
              // formKey.currentState.save();
              return null;
            }
          },
          /* onSaved: (String step){
            //want to add the input to the recipe object
            recipe.steps.add(step);
          }, */
        ),
      ));

    listOfSteps.add(
      Center(
        child: RaisedButton(
          child: Text("Add step"),
          onPressed: () {
            setState(() {
              steps++;
            });
          },
        ),
      ),
    );

    return listOfSteps;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: buildSteps(),
    );
  }
}
