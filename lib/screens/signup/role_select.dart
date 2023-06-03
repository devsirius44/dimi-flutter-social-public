import 'package:flutter/material.dart';
import 'package:social_app/models/user_tbl.dart';
import 'package:social_app/screens/common_widget/custom_button.dart';

class RoleSelect extends StatelessWidget {

  final ValueChanged<Role> onSelected;
  final VoidCallback onNext;
  //final bool isMan;
  const RoleSelect(/*this.isMan,*/ {Key key, this.onSelected, this.onNext}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: <Widget>[          
          SizedBox(height: 20),
          Card(
            elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
            
            child: Container(
              margin: EdgeInsets.all(7),
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12, width: 1.0)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/images/face-icon.png', width: 70, fit: BoxFit.fitWidth),
                  Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 15),
                    child: Text('Role', style:TextStyle(fontFamily: 'PlayfairDisplay-Italic', fontSize: 20)),
                  ),
                  CustomButton(text: 'SUGAR DADDY', onPressed: (){
                    onSelected(Role.SUGAR_DADDY); 
                  }),
                  SizedBox(height: 10),
                  CustomButton(text: 'SUGAR MOMMY', onPressed: (){
                    onSelected(Role.SUGAR_MOMMY);
                  }),
                  SizedBox(height: 10),
                  CustomButton(text: 'SUGAR COUPLE', onPressed: (){
                    onSelected(Role.SUGAR_COUPLE);
                  }),
                  SizedBox(height: 10),
                  CustomButton(text: 'SUGAR BABY', onPressed: (){
                    onSelected(Role.SUGAR_BABY);
                  }),
                  SizedBox(height: 15,),
                  Text('Sugar Daddy/Sugar Mommy: Pampers Sugar Babies\nin return for companionship.', textAlign: TextAlign.center, style: TextStyle(fontSize: 10),),
                  SizedBox(height: 15,),
                  Text('Sugar Baby: Provides companionship in exchange\nfor being pampered.', textAlign: TextAlign.center, style: TextStyle(fontSize: 10),),
                ]                  
              )
            ),
          )
        ],
      ),
    );
  }
}

