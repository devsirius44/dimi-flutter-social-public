import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:social_app/screens/common_widget/app_popup_menu.dart';
import 'package:social_app/screens/common_widget/custom_tab.dart';
import 'package:social_app/screens/common_widget/decorated_tab_bar.dart';
import 'package:social_app/screens/dashboard/nav_menu.dart';
import 'package:social_app/screens/login_screen.dart';
import 'package:social_app/screens/profile/basic_info_page.dart';
import 'package:social_app/screens/profile/description_info_page.dart';
import 'package:social_app/screens/profile/location_info_page.dart';
import 'package:social_app/screens/profile/personal_info_page.dart';
import 'package:social_app/screens/profile/photo_info_page.dart';
import 'package:social_app/utils/singletons/global.dart';
import 'package:social_app/utils/singletons/session_manager.dart';
import 'package:progress_hud/progress_hud.dart';

class ProfileScreen extends StatefulWidget {

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  ProgressHUD _progressHUD;
  ProgressHUD _progressHudLoad;
  bool showDropdownList = false;
  File avatarFile;
  String email;
  int tapIndex = 0;
  
  @override
  void initState() {
    super.initState();
    email = SessionManager.getEmail();
    avatarFile = File(SessionManager.getAvatarPath(email));

    _progressHUD = new ProgressHUD(loading: false, backgroundColor: Colors.black12, color: Colors.white,
      containerColor: Color(0xff5B4961), borderRadius: 5.0, text: 'Uploading...',);

    _progressHudLoad = new ProgressHUD(loading: true, backgroundColor: Colors.black12, color: Color(0xFF493f4e),
      containerColor: Color(0xfff2b349), borderRadius: 5.0, text: 'Loading...',);    

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
              },
              child: Align(alignment: Alignment.centerRight, child: Image.file(avatarFile, height: 70))),
            ],
          ),
     
          drawer: Drawer(
            child: NavMenu(onMenuItemClicked: (value) { },
             onClose: () {
                Navigator.pop(context);
              }
            ),
          ),

          body: Container(
            child: DefaultTabController(
              length: 5,
              child: Column(
                children: <Widget>[
                  DecoratedTabBar(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xff4a414e),
                          width: 2.0,
                        ),
                      ),
                    ),
                    tabBar: TabBar(
                      isScrollable: true,
                      labelColor: Color(0xff4a414e),
                      labelStyle: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w700, fontFamily: 'Lao-Heavy'),
                      unselectedLabelColor: Color(0xff69666b),
                      unselectedLabelStyle: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, fontFamily: 'Lao-Heavy'),
                      indicatorColor: Colors.orange,
                      tabs: [
                        CustomTab(text:'   BASIC INFO   '),
                        CustomTab(text:'   PERSONAL INFO   '),
                        CustomTab(text:'   PHOTOS   '),
                        CustomTab(text:'   LOCATIONS  '),
                        CustomTab(text:'   DESCRIPTION  '),
                      ],
                      onTap: (index) {
                        if(tapIndex != index){
                          _progressHudLoad.state.show();
                          tapIndex = index;
                        } 
                      },
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: <Widget>[
                        BasicInfoPage( onLoadStarted: (hudFlag) {
                          setState(() {
                            if(!hudFlag) {
                              _progressHudLoad.state.dismiss();
                            }
                          });
                        },),
                        //BasicInfoPage(),
                        PersonalInfoPage( onLoadStarted: (hudFlag) {
                          setState(() {
                            if(!hudFlag)
                              _progressHudLoad.state.dismiss();
                          });
                        },),
                        PhotoInfoPage(onAvatarChanged: (val) {                          
                          setState(() {
                            avatarFile = val;
                          });
                        },
                        onImagePickered: (val) {
                          setState(() {
                            bool imagePickered = val;
                            if(imagePickered) {
                              _progressHUD.state.show();
                            }else {
                              _progressHUD.state.dismiss();
                            }
                          });
                        },
                        onLoadStarted: (hudFlag){
                          setState(() {
                            if(!hudFlag){
                              _progressHudLoad.state.dismiss();
                            }
                          });
                        },
                        ),
                        LocationInfoPage(onLoadStarted: (hudFlag) {
                          setState(() {
                            if(!hudFlag){
                              _progressHudLoad.state.dismiss();
                            }
                          });
                        },),
                        DescriptionInfoPage(onLoadStarted: (hudFlag) {
                          setState(() {
                            if(!hudFlag){
                              _progressHudLoad.state.dismiss();
                            }
                          });
                        },),

                      ],
                    ),                
                  ),              
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

        _progressHUD,

        _progressHudLoad

      ],
    );
  }
}