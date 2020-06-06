// https://stackoverflow.com/questions/56386039/how-to-remove-a-textfield-from-listview-when-onpressed-button?fbclid=IwAR33FFAUmxQ4Ji-dUyGIyWPiAHPFCoJKq8xrwkVoVbVf27hN-C7aJGHw3Fw
import 'package:cibus/services/models/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/my_text_form_field.dart';
import '../../services/models/recipe.dart';
import 'package:provider/provider.dart';

// needs to be StatefulWidget, so we can keep track of the count of the fields internally
class RecipeSteps extends StatefulWidget {
  RecipeSteps({
    this.initialCount = 1,
    this.formkey,
    this.recipe,
  });
  // also allow for a dynamic number of starting players
  final int initialCount;
  //formkey from add recipe form and the recipe object
  GlobalKey<FormState> formkey;
  Recipe recipe;

  @override
  _RecipeStepsState createState() => _RecipeStepsState();
}

class _RecipeStepsState extends State<RecipeSteps> {
  int fieldCount = 0;
  int nextIndex = 0;

  // you must keep track of the TextEditingControllers if you want the values to persist correctly
  List<TextEditingController> controllers = <TextEditingController>[];

  // create the list of TextFields, based off the list of TextControllers
  List<Widget> _buildList() {
    int i;
    // fill in keys if the list is not long enough (in case we added one)
    if (controllers.length < fieldCount) {
      for (i = controllers.length; i < fieldCount; i++) {
        controllers.add(TextEditingController());
      }
    }

    i = 0;
    // cycle through the controllers, and recreate each, one per available controller
    return controllers.map<Widget>((TextEditingController controller) {
      int displayNumber = i + 1;
      i++;

      return Padding(
        padding: EdgeInsets.all(8.0),
        child: MyTextFormField(
          controller: controller,
          maxLength: 400,
          maxLines: 5,
          labelText: "Step $displayNumber",
          decoration: InputDecoration(),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.grey,
            ),
            onPressed: () {
              // when removing a TextField, you must do two things:
              // 1. decrement the number of controllers you should have (fieldCount)
              // 2. actually remove this field's controller from the list of controllers
              setState(() {
                fieldCount--;
                controllers.remove(controller);
              });
            },
          ),
          //validate input in MYTextFormField
          validator: (String step) {
            if (step.isEmpty) {
              return 'Enter a Description';
            } else {
              //widget.formkey.currentState.save();
              return null;
            }
          },
          //when pressing submit button to save form
          onSaved: (String step) {
            print('once');
            //widget.recipe.listOfSteps[displayNumber - 1] = step;
            Provider.of<Recipe>(context, listen: false)
                .addSteps(step, displayNumber - 1);
          },
        ),
      );
    }).toList(); // convert to a list
  }

  @override
  Widget build(BuildContext context) {
    // generate the list of TextFields
    final List<Widget> children = _buildList();

    // append an 'add step' button to the end of the list
    children.add(
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: RaisedButton(
          color: Colors.grey[300],
          splashColor: kWarmOrange,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Add another step',
              style:
              TextStyle(fontSize: 16.0),
            ),
          ),
          onPressed: () {
            // when adding a step, we only need to inc the fieldCount, because the _buildList()
            // will handle the creation of the new TextEditingController
            setState(() {
              fieldCount++;
            });
          },
        ),
      ),
    );

    // build the ListView
    return ListView(
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: children,
    );
  }

  @override
  void initState() {
    super.initState();

    // upon creation, copy the starting count to the current count
    fieldCount = widget.initialCount;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(RecipeSteps oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
