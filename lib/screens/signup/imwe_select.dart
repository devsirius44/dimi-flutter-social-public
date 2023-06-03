import 'package:flutter/material.dart';
import 'package:social_app/models/user_tbl.dart';
import 'package:social_app/screens/common_widget/custom_button.dart';

class ImWeSelect extends StatelessWidget {

  final ValueChanged<Imwe> onSelected;
  final Role role;
  const ImWeSelect(this.role, {Key key, this.onSelected}) : super(key: key);
  
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
                  Image.asset('assets/images/person-icon.png', width: 70, fit: BoxFit.fitWidth),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Text('I\'m/We are a', style:TextStyle(fontFamily: 'PlayfairDisplay-Italic', fontSize: 20)),
                  ),
                  Visibility(visible: role == Role.SUGAR_DADDY || role == Role.SUGAR_BABY, child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: CustomButton(text: 'MAN', onPressed: (){
                      onSelected(Imwe.MAN);
                    }),
                  )),
                  
                  Visibility(
                    visible: role == Role.SUGAR_MOMMY || role == Role.SUGAR_BABY,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CustomButton(text: 'WOMAN', onPressed: (){
                        onSelected(Imwe.WOMAN);
                      }),
                    ),
                  ),
                  
                  Visibility(
                    visible: role == Role.SUGAR_COUPLE,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CustomButton(text: 'MAN+WOMAN', onPressed: (){
                        onSelected(Imwe.MAN_WOMAN);
                      }),
                    ),
                  ),
                  Visibility(
                    visible: role == Role.SUGAR_COUPLE,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CustomButton(text: 'WOMAN+WOMAN', onPressed: (){
                        onSelected(Imwe.WOMAN_WOMAN);
                      }),
                    ),
                  ),
                  Visibility(
                    visible: role == Role.SUGAR_COUPLE,
                    child: CustomButton(text: 'MAN+MAN', onPressed: (){
                      onSelected(Imwe.MAN_MAN);
                    })
                  ),
                ] 
              )
            ),
          )
        ],
      ),
    );
  }
}

