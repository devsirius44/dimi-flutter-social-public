import 'package:flutter/material.dart';
import 'package:social_app/screens/common_widget/custom_checkbox.dart';

class BodyTypeCheckBoxs extends StatefulWidget {
  @override
  _BodyTypeCheckBoxsState createState() => _BodyTypeCheckBoxsState();
}

class _BodyTypeCheckBoxsState extends State<BodyTypeCheckBoxs> {

  @override
  Widget build(BuildContext context) {
    
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CustomCheckBox(),
                          SizedBox(width: 15,),
                          Text('Slim')
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: <Widget>[
                          CustomCheckBox(),
                          SizedBox(width: 15,),
                          Text('Athletic')
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: <Widget>[
                          CustomCheckBox(),
                          SizedBox(width: 15,),
                          Text('Average')
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: <Widget>[
                          CustomCheckBox(),
                          SizedBox(width: 15,),
                          Text('Curvy')
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: <Widget>[
                          CustomCheckBox(),
                          SizedBox(width: 15,),
                          Text('A Few Extra')
                        ],
                      ),

                    ],

                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CustomCheckBox(),
                          SizedBox(width: 15,),
                          Text('Pounds')
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: <Widget>[
                          CustomCheckBox(),
                          SizedBox(width: 15,),
                          Text('Full/')
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: <Widget>[
                          CustomCheckBox(),
                          SizedBox(width: 15,),
                          Text('Overweight')
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: <Widget>[
                          CustomCheckBox(),
                          SizedBox(width: 15,),
                          Text('Other')
                        ],
                      ),
                    ],
                  ),
                )  
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}