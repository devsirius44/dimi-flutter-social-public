import 'package:flutter/material.dart';
import 'package:social_app/screens/common_widget/custom_radio_button.dart';

class RadioBtnList extends StatefulWidget {
  final ValueChanged<String> onSelscted;

  const RadioBtnList({Key key, this.onSelscted}) : super(key: key);
  @override
  _RadioBtnListState createState() => _RadioBtnListState();
}

class _RadioBtnListState extends State<RadioBtnList> {
  
  int selectedIndex = 0;
  
  onSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
    String selected;
    switch(index) {
      case 0: 
        selected = 'Men';
        break;
      case 1: 
        selected = 'Women';
        break;
      case 2: 
        selected = 'Both';
        break;
      
    }
    widget.onSelscted(selected);
  }
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CustomRadioButton(
          label: 'Men',
          value: selectedIndex == 0,
          onChanged: (value) {
            onSelected(0);   
          },
        ),
        SizedBox(width: 20,),
        CustomRadioButton(
          label: 'Women',
          value: selectedIndex == 1,
          onChanged: (value) {
            onSelected(1);   
          },
        ),
        SizedBox(width: 20,),
        CustomRadioButton(
          label: 'Both',
          value: selectedIndex == 2,
          onChanged: (value) {
            onSelected(2);   
          },
        ),
      ],
    );
  }
}