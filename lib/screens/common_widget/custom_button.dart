import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double fontSize;
  final VoidCallback onPressed;
  const CustomButton({Key key, this.onPressed, this.text, this.fontSize = 13}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          margin: EdgeInsets.all(0),
          child: InkWell(
            onTap: onPressed,
            child: Container(
              width: constraints.maxWidth,
              height: 55,
              color: Color(0xFF413547), 
              child: Center(child: Text(text, style: TextStyle(color: Colors.white, fontFamily: 'Lato-Heavy', fontSize: 13))),
            ),
          ),
        );
      }
    );
  }
}