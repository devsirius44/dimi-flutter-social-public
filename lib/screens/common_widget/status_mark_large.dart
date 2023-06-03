import 'package:flutter/material.dart';

class StatusMarkLarge extends StatelessWidget {
  
  final Color backgroundColor;
  final String status;
  final double fontSize;

  const StatusMarkLarge(this.status, {Key key, this.backgroundColor = Colors.white, this.fontSize = 12}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Text(status, style: TextStyle(color: Colors.white, height: 1, fontFamily: 'Lato-Regular', fontSize: fontSize),),
    );
  }
}