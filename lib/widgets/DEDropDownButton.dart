import 'package:flutter/material.dart';

// Function to convert dropdown data to string representation
typedef ToStringFunction = String Function<T>(T);
// Callback function that is called when selection is changed
typedef OnSelectedCallback = void Function<T>(T);

// Generic DropDownButton widget accepting different types of values
class DEDropDownButton<T> extends StatefulWidget {
  final String label;
  final T selectedValue;
  final List<T> values;
  final ToStringFunction toStringFunction;
  final OnSelectedCallback callback;

  DEDropDownButton(this.label, this.selectedValue, this.values, this.toStringFunction, {this.callback});

  @override
  State<StatefulWidget> createState() {
    return DEDropDownButtonState(this.label, this.selectedValue, this.values, this.toStringFunction, this.callback);
  }
}

class DEDropDownButtonState<T> extends State<DEDropDownButton> {
  String label;
  T selectedValue;
  List<T> values;
  ToStringFunction toStringFunction;
  OnSelectedCallback callback;

  DEDropDownButtonState(this.label, this.selectedValue, this.values, this.toStringFunction, this.callback);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
        decoration: InputDecoration(labelText: label),
        value: selectedValue,
        //isExpanded: true,
        items: values
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Align(
                      alignment: FractionalOffset.center,
                      child: Text(
                        toStringFunction(e),
                        style: Theme.of(context).textTheme.button,
                      )),
                ))
            .toList(),
        onChanged: (T value) {
          setState(() {
            selectedValue = value;
          });
          if (callback != null) {
            callback(value);
          }
        });
  }
}
