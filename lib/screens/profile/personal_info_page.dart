import 'package:flutter/material.dart';
import 'package:social_app/firebase/profile_manage.dart';
import 'package:social_app/models/appearance_info.dart';
import 'package:social_app/models/personal_info.dart';
import 'package:social_app/screens/common_widget/bottom_region.dart';
import 'package:social_app/screens/common_widget/custom_button.dart';
import 'package:social_app/screens/common_widget/custom_dropdown.dart';
import 'package:social_app/utils/singletons/global.dart';

class PersonalInfoPage extends StatefulWidget {
  final Function onLoadStarted;

  const PersonalInfoPage({Key key, this.onLoadStarted}) : super(key: key);
  @override
  PersonalInfoPageState createState() => PersonalInfoPageState();
}

class PersonalInfoPageState extends State<PersonalInfoPage> {
  List<String> heightList = ['168 cm','169 cm','170 cm','171 cm','172 cm','173 cm','174 cm','175 cm','176 cm','177 cm','178 cm','179 cm','180 cm','181 cm','182 cm','183 cm','184 cm','185 cm'];
  List<String> bodyTypeList = ['Athletic', 'Ectomorph', 'Endomorph'];
  List<String> ethnicityList = ['White/Caucasion','Black/Caucasion','Gold/Caucasion'];
  List<String> eyeColorList = ['Grey', 'Blue','Black'];
  List<String> hairColorList = ['Black','Gold','Brown'];
  List<String> occupationList = ['Yes','No'];
  List<String> educationList = ['High School','College','University'];
  List<String> relationshipList = ['Single','Both'];
  List<String> childrenList = ['Prefer not to say','Prefer to say'];
  List<String> smokingList = ['Light smoker','Heavy smoker', 'Not'];
  List<String> drinkingList = ['Non drinker','Light drinker', 'Strong drinker'];
  List<String> languageList = ['English','Russia','China'];
  //int genderRadio = 0;

  String heightStr = '168 cm';
  String bodytypeStr = 'Athletic';
  String ethnicityStr = 'White/Caucasion';
  String eyecolorStr = 'Grey';
  String haircolorStr = 'Black';
  String occupationStr = 'Yes';
  String educationStr = 'High School';
  String relationshipStr = 'Single';
  String childrenStr = 'Prefer not to say';
  String smokingStr = 'Light smoker';
  String drinkingStr = 'Non drinker';
  String languageStr = 'English';

  AppearanceInfo apInfo = AppearanceInfo('', '', '', '', '', '' );
  PersonalInfo psInfo = PersonalInfo('', '', '', '', '', '', '', '');

  @override
  void initState() {
    getPersonalInfo(); 
    super.initState();
  }

  void getPersonalInfo() async {
    apInfo = await ProfileManage.getCurUserAppearanceInfo();
    psInfo = await ProfileManage.getCurUserPersonalInfo();

    if(apInfo != null) {
      heightStr = apInfo.height;
      bodytypeStr = apInfo.bodytype;
      ethnicityStr = apInfo.ethnicity;
      eyecolorStr = apInfo.eyecolor;
      haircolorStr = apInfo.haircolor;
    } 

    if(psInfo != null) {
      occupationStr = psInfo.occupation;
      educationStr = psInfo.education;
      relationshipStr = psInfo.relationship;
      childrenStr = psInfo.children;
      smokingStr = psInfo.smoking;
      drinkingStr = psInfo.drinking;
      languageStr = psInfo.language;
    }

    setState(() { });

    widget.onLoadStarted(false);

  }

  void savePersonalInfo() async {
    apInfo = AppearanceInfo('', heightStr, bodytypeStr, ethnicityStr, eyecolorStr, haircolorStr );
    psInfo = PersonalInfo('', occupationStr, educationStr, relationshipStr, childrenStr, smokingStr, drinkingStr, languageStr);

    bool flag = await ProfileManage.savePersonalInfo(apInfo, psInfo);
    if(flag) {
      Global.showToastMessage('It was saved successfully.');
    }else{
      Global.showToastMessage('Save was failed.');
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

                  // Appearance field
                  Text('Appearance', style:TextStyle(color: Color(0xff342e37), fontFamily: 'PlayfairDisplay', fontSize: 28)),
                  SizedBox(height: 20,),

                  Container(
                    color: Color(0xffebebec),
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Height:', style: TextStyle(color: Color(0xff4a414e), fontFamily: 'Lato-Regular', fontSize: 17)),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 10,
                              // child: DropDownList(itemList: heightList, onChanged: (val) {
                              //   heightStr = val;
                              // },),
                              child:CustomDropDownButton(listItems: heightList, initialValue: '$heightStr', onPressed: (val) {
                                setState(() {
                                  heightStr = val;
                                });
                              },),
                            ),
                          ],
                        ),
                      ],
                    )
                  ),

                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Body type:', style: TextStyle(color: Color(0xff4a414e), fontFamily: 'Lato-Regular', fontSize: 17)),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 10,
                              // child: DropDownList(itemList: bodyTypeList, onChanged: (val) {
                              //   bodytypeStr = val;
                              // },),
                              child:CustomDropDownButton(listItems: bodyTypeList, initialValue: '$bodytypeStr', onPressed: (val) {
                                setState(() {
                                  bodytypeStr = val;
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
                        Text('Ethnicity:', style: TextStyle(color: Color(0xff4a414e), fontFamily: 'Lato-Regular', fontSize: 17)),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 10,
                              // child: DropDownList(itemList: ethnicityList, onChanged: (val) {
                              //   ethnicityStr = val;
                              // },),
                              child:CustomDropDownButton(listItems: ethnicityList, initialValue: '$ethnicityStr', onPressed: (val) {
                                setState(() {
                                  ethnicityStr = val;
                                });
                              },),
                              
                            ),
                          ],
                        ),
                      ],
                    )
                  ),

                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Eye color:', style: TextStyle(color: Color(0xff4a414e), fontFamily: 'Lato-Regular', fontSize: 17)),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 10,
                              // child: DropDownList(itemList: eyeColorList, onChanged: (val) {
                              //   eyecolorStr = val;
                              // },),
                              child:CustomDropDownButton(listItems: eyeColorList, initialValue: '$eyecolorStr', onPressed: (val) {
                                setState(() {
                                  eyecolorStr = val;
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
                        Text('Hair color:', style: TextStyle(color: Color(0xff4a414e), fontFamily: 'Lato-Regular', fontSize: 17)),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 10,
                              // child: DropDownList(itemList: hairColorList, onChanged: (val) {
                              //   haircolorStr = val;
                              // },),
                              child:CustomDropDownButton(listItems: hairColorList, initialValue: '$haircolorStr', onPressed: (val) {
                                setState(() {
                                  haircolorStr = val;
                                });
                              },),

                            ),
                          ],
                        ),
                      ],
                    )
                  ),

                  // Personal Info field
                  Text('Personal Info', style:TextStyle(color: Color(0xff342e37), fontFamily: 'PlayfairDisplay', fontSize: 28)),
                  SizedBox(height: 20,),

                  Container(
                    color: Color(0xffebebec),
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Occupation:', style: TextStyle(color: Color(0xff4a414e), fontFamily: 'Lato-Regular', fontSize: 17)),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 10,
                              // child: DropDownList(itemList: occupationList, onChanged: (val) {
                              //   occupationStr = val;
                              // },),
                              child:CustomDropDownButton(listItems: occupationList, initialValue: '$occupationStr', onPressed: (val) {
                                setState(() {
                                  occupationStr = val;
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
                        Text('Education:', style: TextStyle(color: Color(0xff4a414e), fontFamily: 'Lato-Regular', fontSize: 17)),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 10,
                              // child: DropDownList(itemList: educationList, onChanged: (val) {
                              //   educationStr = val;
                              // },),
                              child:CustomDropDownButton(listItems: educationList, initialValue: '$educationStr', onPressed: (val) {
                                setState(() {
                                  educationStr = val;
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
                        Text('Relationship:', style: TextStyle(color: Color(0xff4a414e), fontFamily: 'Lato-Regular', fontSize: 17)),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 10,
                              // child: DropDownList(itemList: relationshipList, onChanged: (val) {
                              //   relationshipStr =  val;
                              // },),
                              child:CustomDropDownButton(listItems: relationshipList, initialValue: '$relationshipStr', onPressed: (val) {
                                setState(() {
                                  relationshipStr = val;
                                });
                              },),

                            ),
                          ],
                        ),
                      ],
                    )
                  ),

                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Children:', style: TextStyle(color: Color(0xff4a414e), fontFamily: 'Lato-Regular', fontSize: 17)),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 10,
                              // child: DropDownList(itemList: childrenList, onChanged: (val) {
                              //   childrenStr  = val;
                              // },),
                              child:CustomDropDownButton(listItems: childrenList, initialValue: '$childrenStr', onPressed: (val) {
                                setState(() {
                                  childrenStr = val;
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
                        Text('Smoking:', style: TextStyle(color: Color(0xff4a414e), fontFamily: 'Lato-Regular', fontSize: 17)),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 10,
                              // child: DropDownList(itemList: smokingList, onChanged: (val) {
                              //   smokingStr = val;
                              // },),
                              child:CustomDropDownButton(listItems: smokingList, initialValue: /*'Not'*/'$smokingStr', onPressed: (val) {
                                setState(() {
                                  smokingStr = val;
                                });
                              },),

                            ),
                          ],
                        ),
                      ],
                    )
                  ),

                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Drinking:', style: TextStyle(color: Color(0xff4a414e), fontFamily: 'Lato-Regular', fontSize: 17)),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 10,
                              // child: DropDownList(itemList: drinkingList, onChanged: (val) {
                              //   drinkingStr = val;
                              // },),
                              child:CustomDropDownButton(listItems: drinkingList, initialValue: '$drinkingStr', onPressed: (val) {
                                setState(() {
                                  drinkingStr = val;
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
                        Text('Language:', style: TextStyle(color: Color(0xff4a414e), fontFamily: 'Lato-Regular', fontSize: 17)),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 10,
                              // child: DropDownList(itemList: languageList, onChanged: (val) {
                              //   languageStr = val;
                              // },),
                              child:CustomDropDownButton(listItems: languageList, initialValue: '$languageStr', onPressed: (val) {
                                setState(() {
                                  languageStr = val;
                                });
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
                    savePersonalInfo(); 
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