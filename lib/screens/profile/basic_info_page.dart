import 'dart:io';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:social_app/firebase/auth_manage.dart';
import 'package:social_app/firebase/profile_manage.dart';
import 'package:social_app/models/basic_info.dart';
import 'package:social_app/models/financial_info.dart';
import 'package:social_app/models/user_tbl.dart';
import 'package:social_app/screens/common_widget/bottom_region.dart';
import 'package:social_app/screens/common_widget/custom_button.dart';
import 'package:social_app/screens/common_widget/custom_dropdown.dart';
import 'package:social_app/screens/common_widget/input_text.dart';
import 'package:social_app/screens/profile/radio_btn_list.dart';
import 'package:social_app/utils/singletons/global.dart';

class BasicInfoPage extends StatefulWidget {
  final Function onLoadStarted;

  const BasicInfoPage({Key key, this.onLoadStarted}) : super(key: key);
  @override
  BasicInfoPageState createState() => BasicInfoPageState();
}

class BasicInfoPageState extends State<BasicInfoPage> {
  
  int genderRadio = 0;
  String userNameStr = 'Your name';
  //String userNameHintStr = 'Your name';
  String headingStr = 'Your heading';
  //String headingHintStr = 'Your heading';
  int dayInt = 1;
  String dayStr = '1';
  int monthInt = 1;
  String monthStr = 'January';
  int yearInt = 1980;
  String yearStr = '1980';
  String lookforStr = 'Men';
  String lifestyleStr = 'Substantial';
  String networthStr = '\$ 500\,000';
  String annIncomeStr = '\$ 75\,000';
  
  List<String> yearsList = ['1980','1981','1982','1983','1984','1985','1986','1987','1988','1989',
                 '1990','1991','1992','1993','1994','1995','1996','1997','1998','2000'];
  List<String> monthsList = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  List<String> daysList = ['1','2','3','4','5','6','7','8','9','10',
                 '11','12','13','14','15','16','17','18','19','20',
                 '21','22','23','24','25','26','27','28','29','30', '31'];
  List<String> lifeStyleList = ['Substantial', 'Secondary'];
  List<String> netWorthList = ['\$ 500\,000','\$ 1000\,000','\$ 10\,000\,000'];
  List<String> annualInComeList = ['\$ 75\,000','\$ 100\,000','\$ 125\,000'];

  BasicInfo basicInfo = BasicInfo('', '', '', '', '', '', '');
  FinancialInfo finclInfo = FinancialInfo('', '', '', '');

  void getBasicInfos() async {
    basicInfo = await ProfileManage.getCurUserBasicInfo();
    finclInfo = await ProfileManage.getCurUserFinancialInfo();

    if(basicInfo != null) {
      userNameStr = basicInfo.name;
      headingStr = basicInfo.heading;
      lookforStr = basicInfo.lookfor; 
      String birthday = basicInfo.birthday;
      DateFormat newFormat = DateFormat('MM-dd-yyyy');
      DateTime bDate = newFormat.parse(birthday);
      dayStr = bDate.day.toString();
      dayInt = int.parse(dayStr);         
      monthStr = monthsList[bDate.month - 1];
      monthInt = bDate.month;
      yearStr = bDate.year.toString();
      yearInt = int.parse(yearStr);
    }
    
    if(finclInfo != null){
      lifestyleStr = finclInfo.lifestyle;
      networthStr = finclInfo.networth;
      annIncomeStr = finclInfo.annuincome;
    }

    setState(() {

    });


    widget.onLoadStarted(false);
  }

  @override
  void initState() {
    super.initState();
    getBasicInfos();
    //widget.onLoadStarted(false);

  }

  void saveBasicInfos() async {
    if(userNameStr == 'Your name') {
      Global.showToastMessage('Please write Username.');
      return;
    } else if (headingStr == 'Your heading'){
      Global.showToastMessage('Please write Heading.');
      return;
    } else {
      DateTime dTime = DateTime(yearInt, monthInt, dayInt);
      DateFormat newFormat = DateFormat('MM-dd-yyyy');
      String date = newFormat.format(dTime);
      
      UserTbl user = await AuthManage.getUserInfo();

      String curAvatarUrl = await ProfileManage.getCurUserAvatarUrl();  // URL uploaded by user 
      
      if((curAvatarUrl == 'Non') || (curAvatarUrl == 'Unknown')){ // default URL 
        String avatarPath = await ProfileManage.getDefaultAvatarPath(user.email, user.gender);
        curAvatarUrl = await ProfileManage.getUploadedPhotoUrl(File(avatarPath));   
      } 

      basicInfo = BasicInfo('Unknown', userNameStr, headingStr, date, lookforStr, 'Unknown', curAvatarUrl);
      finclInfo = FinancialInfo('', lifestyleStr, networthStr, annIncomeStr);
      
      bool flag = await ProfileManage.saveBasicInfo(basicInfo, finclInfo);
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

                  // Basic Infomation field
                  Text('Basic Infomation', style:TextStyle(color: Color(0xff342e37), fontFamily: 'PlayfairDisplay', fontSize: 28)),
                  SizedBox(height: 20,),
                  Container(
                    color: Color(0xffebebec),
                    padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Username:', style: TextStyle(color: Color(0xff4a414e), fontFamily: 'Lato-Regular', fontSize: 17)),
                        SizedBox(height: 5),
                        InputText(hint: '$userNameStr', fontFamily: 'Lato-Regular', fSize: 17,textAlign: TextAlign.left,containerFlag: true, 
                        onChangedText: (value){
                          userNameStr = value;
                        },),                        
                        SizedBox(height: 5),
                        Text('Stay safe, don\'t use your real name.', style: TextStyle(color: Color(0xff4a414e), fontFamily: 'Lato-Regular', fontSize: 13)),
                      ],
                    )
                  ),

                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Heading:', style: TextStyle(color: Color(0xff4a414e), fontFamily: 'Lato-Regular', fontSize: 17)),
                        SizedBox(height: 5),
                        InputText(hint: '$headingStr', fontFamily: 'Lato-Regular', fSize: 17,textAlign: TextAlign.left, containerFlag: true,
                        onChangedText: (value){
                          headingStr = value;
                        },),
                        SizedBox(height: 5),
                        Text('Add a short summary about yourself that will grab a member\'s affection.', style: TextStyle(color: Color(0xff4a414e), fontFamily: 'Lato-Regular', fontSize: 13)),
                      ],
                    )
                  ),

                  Container(
                    color: Color(0xffebebec),
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Birth date:', style: TextStyle(color: Color(0xff4a414e), fontFamily: 'Lato-Regular', fontSize: 17)),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 12,
                              child:CustomDropDownButton(listItems: daysList, initialValue: '$dayStr', onPressed: (val) {
                                setState(() {
                                  dayStr = val;
                                  dayInt = int.parse(val);  
                                });  
                                
                              },),
                            ),
                            SizedBox(width: 5),                            
                            Expanded(
                              flex: 18,
                              child:CustomDropDownButton(listItems: monthsList, initialValue: '$monthStr', onPressed: (val) {
                                setState(() {
                                  monthStr = val;
                                  monthInt = monthsList.indexOf(val) + 1;
                                });
                                
                              },),
 
                            ),
                            SizedBox(width: 5),                            
                            Expanded(
                              flex: 15,
                              child:CustomDropDownButton(listItems: yearsList, initialValue: '$yearStr', onPressed: (val) {
                                setState(() {
                                  yearStr = val;
                                  yearInt = int.parse(val);
                                });                                
                              },),

                            )
                          ],
                        ),
                      ],
                    )
                  ),

                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 25),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Looking for:', style: TextStyle(color: Color(0xff4a414e), fontFamily: 'Lato-Regular', fontSize: 17)),
                        SizedBox(height: 5),
                        RadioBtnList(onSelscted: (val) {
                          setState(() {
                            lookforStr = val;  
                          });                           
                        },)
                      ],
                    )
                  ),

                  // Financial Infomation field
                  Text('Financial Infomation', style:TextStyle(color: Color(0xff342e37), fontFamily: 'PlayfairDisplay', fontSize: 28)),
                  SizedBox(height: 20,),

                  Container(
                    color: Color(0xffebebec),
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Lifestyle:', style: TextStyle(color: Color(0xff4a414e), fontFamily: 'Lato-Regular', fontSize: 17)),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 10,
                              child:CustomDropDownButton(listItems: lifeStyleList, initialValue: '$lifestyleStr', onPressed: (val) {
                                setState(() {
                                  lifestyleStr = val;
                                });
                              },),

                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text('Tell members what your normal spending habits are.', style: TextStyle(color: Color(0xff4a414e), fontFamily: 'Lato-Regular', fontSize: 13)),
                      ],
                    )
                  ),

                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Net worth:', style: TextStyle(color: Color(0xff4a414e), fontFamily: 'Lato-Regular', fontSize: 17)),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 10,
                              child:CustomDropDownButton(listItems: netWorthList, initialValue: '$networthStr', onPressed: (val) {
                                setState(() {
                                  networthStr = val;
                                });
                              },),

                            ),
                          ],
                        ),
                      ],
                    )
                  ),

                  Container(
                    color: Color(0xffebebec),
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Annual Income:', style: TextStyle(color: Color(0xff4a414e), fontFamily: 'Lato-Regular', fontSize: 17)),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 10,
                              // child: DropDownList(itemList: annualInComeList, onChanged: (val){
                              //   annIncomeStr = val;
                              // },),
                              child:CustomDropDownButton(listItems: annualInComeList, initialValue: '$annIncomeStr', onPressed: (val) {
                                annIncomeStr = val;
                              },),
                            ),
                          ],
                        ),
                      ],
                    )
                  ),

                  // Save Changes
                  SizedBox(height: 30),
                  CustomButton( text: 'SAVE CHANGES', fontSize: 13, onPressed: () {
                    //print('Clicked Save Changes button.');
                    saveBasicInfos(); 
                  },),

                ],
              ),
            ),

            SizedBox(height: 53,),

            BottomRegion()
          ],

        ),
      ),
    );
  }
}