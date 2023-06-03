import 'package:flutter/material.dart';

class CustomDropDownButton extends StatelessWidget {
  final String label;
  final ValueChanged<String> onPressed;
  final List<String> listItems;
  final String initialValue;

  CustomDropDownButton({this.label, this.onPressed, this.listItems,
      this.initialValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      decoration: BoxDecoration(
        color:Colors.white,
        border: Border.all(width: 1, color: Colors.black)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new DropdownButton<String>(
            isExpanded: true,
            value: initialValue,
            isDense: true,
            items:
            listItems.map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            onChanged: (value){
              onPressed(value);
            }
          ),
        ],
      ),
    );
  }
}
