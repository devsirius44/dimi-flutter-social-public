import 'package:flutter/material.dart';
import 'package:social_app/firebase/profile_manage.dart';
import 'package:social_app/models/description_info.dart';
import 'package:social_app/screens/common_widget/bottom_region.dart';
import 'package:social_app/screens/common_widget/custom_button.dart';
import 'package:social_app/screens/common_widget/input_text.dart';
import 'package:social_app/utils/singletons/global.dart';

class DescriptionInfoPage extends StatefulWidget {
  final Function onLoadStarted;

  const DescriptionInfoPage({Key key, this.onLoadStarted}) : super(key: key);

  @override
  DescriptionInfoPageState createState() => DescriptionInfoPageState();
}

class DescriptionInfoPageState extends State<DescriptionInfoPage> {
  String aboutmeStr = 'A little bit about myself';
  String wilookforStr = 'The type of person you\'re looking\n for';
  //String aboutmeHintStr = 'A little bit about myself';
  //String wilookforHintStr = 'The type of person you\'re looking\n for';

  DescriptionInfo dsInfo = DescriptionInfo('', '', '');
  
  getDescriptionInfo() async {
    dsInfo = await ProfileManage.getCurUserDescriptionInfo();
    if(dsInfo != null){
      aboutmeStr = dsInfo.aboutme;
      //aboutmeHintStr = dsInfo.aboutme;
      wilookforStr = dsInfo.wilookfor;
      //wilookforHintStr = dsInfo.wilookfor;
    }
    setState(() {
      
    });
    widget.onLoadStarted(false);
  }

  @override
  void initState() {
    getDescriptionInfo();

    super.initState();
  }

  void saveDescriptionInfo() async {
    if(aboutmeStr == 'A little bit about myself'){
      Global.showToastMessage('Please write the About me');
      return;
    } else if(wilookforStr == 'The type of person you\'re looking\n for'){
      Global.showToastMessage('Please write the What I am looking for.');
      return;
    } else {
      dsInfo = DescriptionInfo('', aboutmeStr, wilookforStr);
      bool flag = await ProfileManage.saveDescriptionInfo(dsInfo);
      if(flag) {
        Global.showToastMessage('It was saved successfully.');
      }else{
        Global.showToastMessage('Save was failed.');
      }       
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 25, left: 15, right: 15),            
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Your description
                  Text('Your description', style:TextStyle(color: Color(0xff342e37), fontFamily: 'PlayfairDisplay', fontSize: 28)),
                  SizedBox(height: 20,),

                  Container(
                    color: Color(0xffebebec),
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('About me:', style: TextStyle(color: Color(0xff4a414e), fontFamily: 'Lato-Regular', fontSize: 17)),
                        SizedBox(height: 5),
                        InputText(hint:'$aboutmeStr', initialText: aboutmeStr, fontFamily: 'Lato-Regular', fSize: 17, containerFlag: true, maxlines: 5, onChangedText: (val) {
                          aboutmeStr = val;
                        },),
                      ],
                    )
                  ),

                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('What I\'m looking for:', style: TextStyle(color: Color(0xff4a414e), fontFamily: 'Lato-Regular', fontSize: 17)),
                        SizedBox(height: 5),
                        InputText(hint:'$wilookforStr', initialText: wilookforStr, fontFamily: 'Lato-Regular', fSize: 17, containerFlag: true, maxlines: 5, onChangedText: (val) {
                          wilookforStr = val;
                        },),
                      ],
                    )
                  ),

                  // Save Changes
                  SizedBox(height: 30),
                  CustomButton( text: 'SAVE CHANGES', fontSize: 13, onPressed: () {
                    //print('Clicked Save Changes button.');
                    saveDescriptionInfo(); 
                  },),

                ],
              ),
            ),

            SizedBox(height: 30,),

            BottomRegion()
          ],

        ),
      ),

    );
  }
}