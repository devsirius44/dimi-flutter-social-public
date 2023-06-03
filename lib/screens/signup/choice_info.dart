import 'package:flutter/material.dart';

class ChoiceInfo extends StatelessWidget {
  final String imgUrl;
  final String propName;
  final String propValue;
  final bool visible;
  const ChoiceInfo({
    Key key,
    @required this.visible, this.imgUrl, this.propName, this.propValue
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Card(          
        margin: EdgeInsets.only(left: 18, right:18, bottom: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0))
        ),  
        elevation: 10,            
        child: Container(
          margin: EdgeInsets.all(2),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12, width: 1.0),                
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(imgUrl, width: 20, fit: BoxFit.fitWidth),
                  SizedBox(width: 8,),
                  Text(propName + ': ', style:TextStyle(fontFamily: 'PlayfairDisplay-Italic', fontSize: 15)),
                  Text(propValue, style: TextStyle(decoration: TextDecoration.underline, color: Colors.black, fontFamily: 'Lato-Regular', fontSize: 15),) //
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}