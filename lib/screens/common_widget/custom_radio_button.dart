import 'package:flutter/material.dart';


class CustomRadioButton extends StatelessWidget {
  
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  
  const CustomRadioButton({Key key, this.label, this.value = false, this.onChanged}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisSize: MainAxisSize.min,children: <Widget>[
        InkWell(onTap: () {
          onChanged(!value);
        }, child: Image.asset(value ? 'assets/images/radio-checked-icon.png' : 'assets/images/radio-unchecked-icon.png', width: 20, fit: BoxFit.fitWidth)),
        SizedBox(width: 5),
        Text(label, style: TextStyle(color: Color(0xFF423547), fontFamily: 'Lato-Regular', fontSize: 14))
      ],
    );
  }
}