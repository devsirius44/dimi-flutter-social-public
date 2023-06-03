import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_app/firebase/dashboard_manage.dart';
import 'package:social_app/models/new_member.dart';
import 'package:social_app/screens/common_widget/app_popup_menu.dart';
import 'package:social_app/screens/common_widget/custom_checkbox.dart';
import 'package:social_app/screens/dashboard/nav_menu.dart';
import 'package:social_app/screens/dashboard/new_members_screen.dart';
import 'package:social_app/screens/login_screen.dart';
import 'package:social_app/screens/profile/profile_screen.dart';
import 'package:social_app/screens/search/filter_screen.dart';
import 'package:social_app/utils/singletons/global.dart';
import 'package:social_app/utils/singletons/session_manager.dart';
import 'package:progress_hud/progress_hud.dart';

class SearchScreen extends StatefulWidget {
  final int tabIndex;

  const SearchScreen({Key key, this.tabIndex = 0}) : super(key: key);
  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {

  bool showDropdownList = false;

  bool maleFlag = true; 
  bool femaleFlag = true;
  bool viewedFlag = true;
  bool unviewFlag = true;
  bool viewMeFlag = true;
  bool photoFlag = true;
  bool favoritedFlag = true;
  bool favorMeFlag = true;
  bool premiumFlag = true;
  bool backgCheckFlag = true;
  bool colledgeFlag = true;

  String email;
  List<NewMember> memberList = [];
  ProgressHUD _progressHUD;

  
  @override
  void initState() {
    super.initState();
    _progressHUD = new ProgressHUD(loading: true, backgroundColor: Colors.black12, color: Color(0xFF493f4e),
      containerColor: Color(0xfff2b349)/*Color(0x99d1d1de)*/, borderRadius: 5.0, text: 'Getting ...',);    
    email = SessionManager.getEmail();
    
    loadSearchHomeMembers();
  }
  
  void loadSearchHomeMembers() async {
    //memberList = await DashboardManage.getNewestMembers();
     memberList = await DashboardManage.getSearchHomeMembers(maleFlag, femaleFlag, viewedFlag, unviewFlag,
                  viewMeFlag, photoFlag, favoritedFlag, favorMeFlag, premiumFlag, backgCheckFlag, colledgeFlag);
    
    if(memberList.length == 0) {
      Global.showToastMessage('There is not newest members.');
    }
    setState(() {
    });
    _progressHUD.state.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff4a414e),
            titleSpacing: 0,
            leading: Align(alignment: Alignment.centerLeft, child: Image.asset('assets/images/da-top-icon.png'),),
            title: Row(
              children: <Widget>[
                Builder(
                  builder: (context) {
                    return IconButton(
                      icon: Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    );
                  },
                )
              ],
            ),
            actions: <Widget>[
              InkWell(onTap: () {
                setState(() {
                  showDropdownList = true;
                });
              }, child: Align(alignment: Alignment.centerRight, child: Image.file(File(SessionManager.getAvatarPath(email)), height: 70))),
            ],
          ),
          
          drawer: Drawer(
            child: NavMenu(onMenuItemClicked: (value) {},),
          ),

          body: Container(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top:15, left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                    print('FILTER taped');
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => FilterScreen()));
                                  },
                                  child: Container(
                                    width: 80, 
                                    height: 38,
                                    color: Color(0xff423547),
                                    child: Center(
                                      child: Text('FILTER', style: TextStyle(color: Colors.white, fontFamily: 'Lato-Rregular', fontSize: 13),
                                    ),),
                                  )
                            ),
                            InkWell(
                              onTap: () {
                                    print('RESETNTLY ACTIVE taped');
                                  },
                                  child: Container(
                                    width: 150, 
                                    height: 38,
                                    color: Color(0xff423547),
                                    child: Center(
                                      child: Text('RESETNTLY ACTIVE', style: TextStyle(color: Colors.white, fontFamily: 'Lato-Rregular', fontSize: 13),
                                    ),),
                                  )
                            ),
                            InkWell(
                              onTap: () {
                                    _progressHUD.state.show();
                                    loadSearchHomeMembers();
                                  },
                                  child: Container(
                                    width: 80, 
                                    height: 38,
                                    color: Color(0xff423547),
                                    child: Center(
                                      child: Text('SAVE', style: TextStyle(color: Colors.white, fontFamily: 'Lato-Rregular', fontSize: 13),
                                    ),),
                                  )
                            ),                             
                          ],      
                        ),
                        SizedBox(height: 15,),

                        Container(
                          color: Color(0xffebebec),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, top: 10),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    CustomCheckBox( 
                                      onChanged: (bool value) {
                                        photoFlag = value;
                                        //loadSearchHomeMembers();
                                        setState(() {

                                        });                          
                                    },),
                                    Text(' Photo', style: TextStyle(color: Color(0xff423547), fontFamily: 'Lato-Regular', fontSize: 14),),
                                    SizedBox(width: 15,),
                                    CustomCheckBox(                              
                                      onChanged: (bool value) {
                                        backgCheckFlag = value;
                                        //loadSearchHomeMembers();
                                        setState(() {

                                        });                          
                                    },),
                                    Text(' Background Check'),
                                    SizedBox(width: 15,),
                                    CustomCheckBox( 
                                      onChanged: (bool value) {
                                        premiumFlag = value;
                                        //loadSearchHomeMembers();
                                        setState(() {

                                        });                          
                                    },),
                                    Text(' Premium'),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: <Widget>[
                                    CustomCheckBox( 
                                      onChanged: (bool value) {
                                        viewedFlag = value;
                                        //loadSearchHomeMembers();
                                        setState(() {

                                        });                          
                                    },),
                                    Text(' Viewed', style: TextStyle(color: Color(0xff423547), fontFamily: 'Lato-Regular', fontSize: 14),),
                                    SizedBox(width: 15,),
                                    CustomCheckBox(                              
                                      onChanged: (bool value) {
                                        //loadSearchHomeMembers();
                                        viewMeFlag = value;
                                        setState(() {

                                        });                          
                                    },),
                                    Text(' Viewed me'),
                                    SizedBox(width: 15,),
                                    CustomCheckBox( 
                                      onChanged: (bool value) {
                                        favoritedFlag = value;
                                        //loadSearchHomeMembers();
                                        setState(() {

                                        });                          
                                    },),
                                    Text(' Favorited'),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: <Widget>[
                                    CustomCheckBox( 
                                      onChanged: (bool value) {
                                        favorMeFlag = value;
                                        //loadSearchHomeMembers();
                                        setState(() {

                                        });                          
                                    },),
                                    Text(' Favorited me', style: TextStyle(color: Color(0xff423547), fontFamily: 'Lato-Regular', fontSize: 14),),
                                    SizedBox(width: 15,),
                                    CustomCheckBox(                              
                                      onChanged: (bool value) {
                                        unviewFlag = value;
                                        //loadSearchHomeMembers();
                                        setState(() {

                                        });                          
                                    },),
                                    Text(' Unviewed'),
                                    SizedBox(width: 15,),
                                    CustomCheckBox( 
                                      onChanged: (bool value) {
                                        colledgeFlag = value;
                                        //loadSearchHomeMembers();
                                        setState(() {

                                        });                          
                                    },),
                                    Text(' College'),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: <Widget>[
                                    CustomCheckBox( 
                                      onChanged: (bool value) {
                                        femaleFlag = value;
                                        //loadSearchHomeMembers();
                                        setState(() {

                                        });                          
                                    },),
                                    Text(' Female', style: TextStyle(color: Color(0xff423547), fontFamily: 'Lato-Regular', fontSize: 14),),
                                    SizedBox(width: 15,),
                                    CustomCheckBox(                              
                                      onChanged: (bool value) {
                                        maleFlag = value;
                                        //loadSearchHomeMembers();
                                        setState(() {

                                        });                          
                                    },),
                                    Text(' Male'),
                                  ],
                                ),
                                SizedBox(height: 50,),

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    child: Column(
                      children: <Widget>[
                        //MemberListScreen(memberType: MemberType.BackgroundVerified,)
                        NewMembersScreen(newMembers: memberList,)
                      ],
                      //
                    ),
                  )
                ],
              ),
            ),
          ),
        ),

        AppPopUpMenu(showDDL: showDropdownList, 
          onAnyPressed: () {
            setState(() {
              showDropdownList = false;
            },);
          }, onProfilePressed: () {
            setState(() {
              showDropdownList = false;
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
            });
          }, onLogOutPressed: () {
            setState(() {
              showDropdownList = false;
              Global.freeSignaling();
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())); 
            }); 
          },
        ),

        _progressHUD
      ],
    );
  }

}