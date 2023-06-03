import 'package:flutter/material.dart';

class StatusMark extends StatelessWidget {
  
  final Color backgroundColor;
  final String status;

  const StatusMark(this.status, {Key key, this.backgroundColor = Colors.white}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      child: Text(status, style: TextStyle(color: Colors.white, height: 1, fontFamily: 'Lato-Regular', fontSize: 10),),
    );
  }
}