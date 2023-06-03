import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:social_app/firebase/dashboard_manage.dart';
import 'package:social_app/models/new_member.dart';
import 'package:social_app/models/user_tbl.dart';
import 'package:social_app/screens/common_widget/app_popup_menu.dart';
import 'package:social_app/screens/common_widget/custom_tab.dart';
import 'package:social_app/screens/common_widget/decorated_tab_bar.dart';
import 'package:social_app/screens/dashboard/nav_menu.dart';
import 'package:social_app/screens/dashboard/new_members_screen.dart';
import 'package:social_app/screens/login_screen.dart';
import 'package:social_app/screens/profile/profile_screen.dart';
import 'package:social_app/utils/singletons/global.dart';
import 'package:social_app/utils/singletons/session_manager.dart';
import 'package:progress_hud/progress_hud.dart';

class DashboardScreen extends StatefulWidget {
  
  final int tabIndex;
  const DashboardScreen({Key key, this.tabIndex=0}) : super(key: key);  
  @override
  DashboardScreenState createState() => DashboardScreenState();  
}

class DashboardScreenState extends State<DashboardScreen> {
  ProgressHUD _progressHUD;
  bool showDropdownList = false;
  String email;
  String avatarUrl='';
  String avatarImg='';
  Gender gender; 
  int index = 0;
  List<NewMember> memberList = [];

  @override
  void initState() {

    super.initState();    
    _progressHUD = new ProgressHUD(loading: true, backgroundColor: Colors.black12, color: Color(0xFF493f4e),
      containerColor: Color(0xfff2b349)/*Color(0x99d1d1de)*/, borderRadius: 5.0, text: 'Getting ...',);    
    email = SessionManager.getEmail();
    avatarUrl = SessionManager.getAvatarPath(email);

    gender = SessionManager.getGender();
    if(gender== Gender.MALE)
      avatarImg = 'assets/images/male-avatar.png';
    else   
      avatarImg = 'assets/images/female-avatar.png';

    loadNewMembers();

  }
  
  void loadNewMembers() async {
      memberList = await DashboardManage.getNewestMembers();
      if(memberList.length == 0) {
        Global.showToastMessage('There is not newest members.');
      }
      setState(() {
      });
      _progressHUD.state.dismiss();
  }

  void loadFeaturedMembers() async {
    //memberList = await DashboardManage.getNewestMembers();
    if(memberList.length == 0) {
      Global.showToastMessage('There is not newest members.');
    }
    setState(() {
    });
    _progressHUD.state.dismiss();
  }

  void loadBackVerifiedMembers() async {
    //memberList = await DashboardManage.getNewestMembers();
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
              }, 
              child: Align(alignment: Alignment.centerRight, child: Image.file(File(SessionManager.getAvatarPath(email)), height: 70)))
            ],
          ),

          drawer: Drawer(
            child: NavMenu(onMenuItemClicked: (value) {
              
            }, onClose: () {
              Navigator.pop(context);
            }),
          ),
          body:Container(
            width: MediaQuery.of(context).size.width,
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 15),
                    child: DecoratedTabBar(
                      tabBar: TabBar(
                        isScrollable: true,
                        labelColor: Color(0xff4a414e),
                        labelStyle: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w700, fontFamily: 'Lao-Heavy'),
                        unselectedLabelColor: Color(0xff69666b),
                        unselectedLabelStyle: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, fontFamily: 'Lao-Heavy'),
                        indicatorColor: Colors.orange,
                        tabs: [
                          CustomTab(text: "NEWEST MEMBERS"),
                          CustomTab(text: "FEATURED MEMBERS"),
                          CustomTab(text: "BACKGROUND VERIFIED"),
                        ],
                        onTap: (val) {                          
                          if(index != val) {
                            _progressHUD.state.show();
                            index = val;
                          }
                          if(index == 0) {
                            loadNewMembers();
                          } else if (index == 1){
                            loadFeaturedMembers();
                          } else {
                            loadBackVerifiedMembers();
                          }
                        },
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xff4a414e),
                            width: 2.0,
                          ),
                        ),
                      ),
                    ), 
                  ),
                  Expanded(
                    child: TabBarView(
                      children: <Widget>[
                        NewMembersScreen(newMembers: memberList,),
                        NewMembersScreen(newMembers: memberList,),
                        NewMembersScreen(newMembers: memberList,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ) 
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
              Navigator.pushNamedAndRemoveUntil(context, '/loginScreen', ModalRoute.withName('/loginScreen'));
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())); 
            }); 
          },
        ),

        _progressHUD
      ],
    );
  }

  
}
