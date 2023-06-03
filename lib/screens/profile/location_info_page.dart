import 'package:flutter/material.dart';
import 'package:social_app/firebase/profile_manage.dart';
import 'package:social_app/screens/common_widget/bottom_region.dart';
import 'package:social_app/screens/common_widget/custom_button.dart';
import 'package:social_app/screens/common_widget/input_text.dart';
import 'package:social_app/utils/singletons/global.dart';

class LocationInfoPage extends StatefulWidget {
  final Function onLoadStarted;

  const LocationInfoPage({Key key, this.onLoadStarted}) : super(key: key);

  @override
  LocationInfoPageState createState() => LocationInfoPageState();
}

class LocationInfoPageState extends State<LocationInfoPage> {
  String curlocationStr = 'Type city here';
  //String curlocationHintStr = 'Type city here';

  @override
  void initState() {
    super.initState();
    getLocationInfo();
  }

  void getLocationInfo() async {
    curlocationStr = await ProfileManage.getCurUserLocationInfo();
    setState(() {
      
    });
    widget.onLoadStarted(false);
  }

  void saveLocationInfo() async {
    if(curlocationStr == 'Type city here'){
      Global.showToastMessage('Please write the User current location.');
      return;
    } else {
      bool flag = await ProfileManage.saveLocationInfo(curlocationStr);
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

                  // Profile Locations
                  Text('Profile Locations', style:TextStyle(color: Color(0xff342e37), fontFamily: 'PlayfairDisplay', fontSize: 28)),
                  SizedBox(height: 20,),

                  Container(
                    color: Color(0xffebebec),
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Image.asset('assets/images/uc-location-icon.png', height: 13,),
                            SizedBox(width: 10,),
                            Text('User current location:', style: TextStyle(color: Color(0xff4a414e), fontFamily: 'Lato-Regular', fontSize: 17)),
                          ],
                        ),
                        SizedBox(height: 5),
                        InputText(hint:'$curlocationStr', fontFamily: 'Lato-Regular', fSize: 17, containerFlag: true, suffixIconFlag: true, onChangedText: (val) {
                          curlocationStr = val;
                        },),
                      ],
                    )
                  ),

                  // Save Changes
                  SizedBox(height: 30),
                  CustomButton( text: 'SAVE CHANGES', fontSize: 13, onPressed: () {
                    //print('Clicked Save Changes button.');
                    saveLocationInfo(); 
                  },),

                ],
              ),
            ),

            SizedBox(height: 53,),

            BottomRegion()
          ],

        ),
      ),
      //child: Text('Location Info'),
    );
  }
}