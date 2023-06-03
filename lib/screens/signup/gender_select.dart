import 'package:flutter/material.dart';
import 'package:social_app/models/user_tbl.dart';
import 'package:social_app/screens/common_widget/custom_button.dart';

class GenderSelect extends StatelessWidget {
  final ValueChanged<Gender> onSelected;

  const GenderSelect({Key key, this.onSelected}) : super(key: key);
  @override
  Widget build(BuildContext context) {
  return Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          margin: EdgeInsets.all(7),
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12, width: 1.0)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/circle-icon.png', width: 70, fit: BoxFit.fitWidth),
              Padding(
                padding: EdgeInsets.only(top: 5, bottom: 15),
                child: Text('Gender', style: TextStyle(fontFamily: 'PlayfairDisplay-Italic', fontSize: 20)),
              ),
              CustomButton(text: 'MALE', onPressed: () {
                onSelected(Gender.MALE);
              }),
              SizedBox(height: 10),
              CustomButton(text: 'FEMALE', onPressed: () {
                onSelected(Gender.FEMALE);
              }),
            
            ]                  
          )
        ),
      );
  }
}